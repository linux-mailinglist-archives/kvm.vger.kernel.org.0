Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C39D32C621
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:01:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350251AbhCDA1n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:27:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51787 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235048AbhCCNdT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 08:33:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614778286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dhKqxKBFkaOlQ3sPGBNWkfrkyTGxOiVdwNieGuR7XW0=;
        b=fk3h1b06/EKuxzUoKff+6cSZvXJ7F/SvujjJLBjkOvA58tYrYog7E58USlyUFkl5FA6lPN
        fb9zYcPDEHSvbROEVoP0/H7ymUPppZaQOuVQCHgYPxhA1A5N2eGVwxTH9KzBCILg98Io6N
        K5tUkKtesMPmSTrM18dUIQEtlDdczXw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-GknLCEs9PLKymz4cClIhpQ-1; Wed, 03 Mar 2021 08:31:25 -0500
X-MC-Unique: GknLCEs9PLKymz4cClIhpQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7438800D53;
        Wed,  3 Mar 2021 13:31:23 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-115-146.ams2.redhat.com [10.36.115.146])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7D085D9DD;
        Wed,  3 Mar 2021 13:31:14 +0000 (UTC)
Subject: Re: [PATCH v1 1/2] s390x/kvm: Get rid of legacy_s390_alloc()
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Cornelia Huck <cohuck@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Peter Xu <peterx@redhat.com>
References: <20210303130916.22553-1-david@redhat.com>
 <20210303130916.22553-2-david@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <93a30708-e893-208b-3dd3-c8b617272966@redhat.com>
Date:   Wed, 3 Mar 2021 14:31:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210303130916.22553-2-david@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/2021 14.09, David Hildenbrand wrote:
> legacy_s390_alloc() was required for dealing with the absence of the ESOP
> feature -- on old HW (< gen 10) and old z/VM versions (< 6.3).
> 
> As z/VM v6.2 (and even v6.3) is no longer supported since 2017 [1]
> and we don't expect to have real users on such old hardware, let's drop
> legacy_s390_alloc().
> 
> Still check+report an error just in case someone still runs on
> such old z/VM environments, or someone runs under weird nested KVM
> setups (where we can manually disable ESOP via the CPU model).
> 
> No need to check for KVM_CAP_GMAP - that should always be around on
> kernels that also have KVM_CAP_DEVICE_CTRL (>= v3.15).

Reviewed-by: Thomas Huth <thuth@redhat.com>


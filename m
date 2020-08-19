Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C3BF249A2C
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 12:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbgHSKWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 06:22:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:58242 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726702AbgHSKWd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 19 Aug 2020 06:22:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597832552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GRx5D5f8kWBgrJZg6fuZJyVem4FF1OPrg/FIFzWAbu0=;
        b=EsF5qmhGyUqauU4MTk/SPYAW4XmncMjFblCIz4JijIUOCBXi9jfZhzAOJuwstZBlWibgFu
        zeOodifL0lsFxszcbcOWDil2Azyrqpmi24Xxt4rtMI3emlZcwgCs7YlWRoU4BQpMfKePho
        HLeSTHgSe42/oTT6015RRaA6UG+H3m4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-KZVEr0IEO4aA2J2vOXxqCQ-1; Wed, 19 Aug 2020 06:22:27 -0400
X-MC-Unique: KZVEr0IEO4aA2J2vOXxqCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 824CD1084C8C;
        Wed, 19 Aug 2020 10:22:26 +0000 (UTC)
Received: from gondolin (ovpn-112-216.ams2.redhat.com [10.36.112.216])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D3E415D9E8;
        Wed, 19 Aug 2020 10:22:21 +0000 (UTC)
Date:   Wed, 19 Aug 2020 12:22:19 +0200
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Hartmayer <mhartmay@linux.ibm.com>
Cc:     <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 2/4] scripts: add support for
 architecture dependent functions
Message-ID: <20200819122219.18a102dd.cohuck@redhat.com>
In-Reply-To: <20200818130424.20522-3-mhartmay@linux.ibm.com>
References: <20200818130424.20522-1-mhartmay@linux.ibm.com>
        <20200818130424.20522-3-mhartmay@linux.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Aug 2020 15:04:22 +0200
Marc Hartmayer <mhartmay@linux.ibm.com> wrote:

> This is necessary to keep architecture dependent code separate from
> common code.
> 
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  README.md           | 3 ++-
>  scripts/common.bash | 8 ++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 

Reviewed-by: Cornelia Huck <cohuck@redhat.com>


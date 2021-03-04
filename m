Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834B832D2D8
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 13:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240448AbhCDM00 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 07:26:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51835 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240453AbhCDM0B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Mar 2021 07:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614860675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VxObeU9oRNIEYPUzsFdsCeXo8HenXTZFo5mB0PbnSaY=;
        b=czrJHF5ztd65PB8C6m6LIr8nIHhvBn+qWnvPIQe6OHD02v6jfSAhUDsySpVebLA0R3jbFS
        cA/aoX8iKpf42gASN98IULfqH0F/NKsKCIb/ZzqZ08aOUD3QGTL3/0WePbyKyb3l7iEkV1
        VdR51+H/A8Up27WGyBx7qlU1sz2pw90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-vS-F6leBOJuWhHZ7eJyWTg-1; Thu, 04 Mar 2021 07:24:31 -0500
X-MC-Unique: vS-F6leBOJuWhHZ7eJyWTg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56BFF87A82A;
        Thu,  4 Mar 2021 12:24:30 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-31.ams2.redhat.com [10.36.112.31])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E37F55D71B;
        Thu,  4 Mar 2021 12:24:25 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Print more information on
 program exceptions
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        pmorel@linux.ibm.com, david@redhat.com
References: <20210222085756.14396-1-frankja@linux.ibm.com>
 <20210222085756.14396-6-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <7869c8a0-bd7b-ab58-fbf9-6106680e2065@redhat.com>
Date:   Thu, 4 Mar 2021 13:24:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210222085756.14396-6-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/2021 09.57, Janosch Frank wrote:
> Currently we only get a single line of output if a test runs in a
> unexpected program exception. Let's also print the general registers
> to give soem more context.

s/soem/some/

With the typo fixed:
Reviewed-by: Thomas Huth <thuth@redhat.com>


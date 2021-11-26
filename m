Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB0B45F28B
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 17:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232208AbhKZQ70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 11:59:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:51926 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234245AbhKZQ50 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 11:57:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637945653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gU9MXczsA1bjhtsrPZMXnBHjqNqsINI4C/eEu8osnNk=;
        b=iBpKO2ACfVDdTCnQFK4K2+4FMhnnzioF7S7l0QPirfw4ore30dMNR+Z6U6VaBv7rbbjlbB
        O4fnigcfW7b4+7PDtSfp6C+O88eZY1QoBPgDASBlHbgnGk7y43VKF9LdmyWmq1hnGBN8z3
        z56guSmwwjxadc0ExoyIb2TZrTuBw40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-wfLn0AKQN065qn2zVGhW5A-1; Fri, 26 Nov 2021 11:54:11 -0500
X-MC-Unique: wfLn0AKQN065qn2zVGhW5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A184E1015DA0;
        Fri, 26 Nov 2021 16:54:10 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47DDE5D6B1;
        Fri, 26 Nov 2021 16:54:09 +0000 (UTC)
Message-ID: <c581fbc0-f836-7927-1bb6-54760b049d2a@redhat.com>
Date:   Fri, 26 Nov 2021 17:54:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [v4][PATCH 2/2] KVM: Clear pv eoi pending bit only when it is set
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Li RongQing <lirongqing@baidu.com>, kvm@vger.kernel.org
Cc:     seanjc@google.com, stable@kernel.org
References: <1636026974-50555-1-git-send-email-lirongqing@baidu.com>
 <1636026974-50555-2-git-send-email-lirongqing@baidu.com>
 <8735nsnmmx.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8735nsnmmx.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/21 17:19, Vitaly Kuznetsov wrote:
> Reviewed-by: Vitaly Kuznetsov<vkuznets@redhat.com>

Queued, thanks.

Paolo


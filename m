Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062EC2219BF
	for <lists+kvm@lfdr.de>; Thu, 16 Jul 2020 04:11:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbgGPCLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jul 2020 22:11:01 -0400
Received: from relay5.mymailcheap.com ([159.100.248.207]:33917 "EHLO
        relay5.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbgGPCLA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jul 2020 22:11:00 -0400
Received: from relay1.mymailcheap.com (relay1.mymailcheap.com [149.56.97.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 7FD2626297;
        Thu, 16 Jul 2020 02:10:57 +0000 (UTC)
Received: from filter1.mymailcheap.com (filter1.mymailcheap.com [149.56.130.247])
        by relay1.mymailcheap.com (Postfix) with ESMTPS id 2FC3B3F157;
        Wed, 15 Jul 2020 22:10:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by filter1.mymailcheap.com (Postfix) with ESMTP id 15DDC2A3AA;
        Wed, 15 Jul 2020 22:10:55 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1594865455;
        bh=AEVS6FARCeqmIOD4dOV3ZjxZYov8SUPADkze2QBtd2U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=QNeGTu/dyMvdNtebwUxhirTxhBf7AL3WE570KPi6c1D51TpCAeXJ9qp/uQ+gXNVlJ
         q12z4Sjd6CIZoXO9fOnFL8ApSr/FBpvzDp97KbxOFqczGMD3mJ3/2653DabEQ9YUMd
         pvRNCTmNpXBnwQ/dNj1iCFsCW5q5aICfmJpyNt0A=
X-Virus-Scanned: Debian amavisd-new at filter1.mymailcheap.com
Received: from filter1.mymailcheap.com ([127.0.0.1])
        by localhost (filter1.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dTfR2iRsKyru; Wed, 15 Jul 2020 22:10:52 -0400 (EDT)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter1.mymailcheap.com (Postfix) with ESMTPS;
        Wed, 15 Jul 2020 22:10:52 -0400 (EDT)
Received: from [148.251.23.173] (ml.mymailcheap.com [148.251.23.173])
        by mail20.mymailcheap.com (Postfix) with ESMTP id C21DF4013E;
        Thu, 16 Jul 2020 02:10:51 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=flygoat.com header.i=@flygoat.com header.b="VNGL71/4";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from [0.0.0.0] (114-42-221-235.dynamic-ip.hinet.net [114.42.221.235])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 14B174013E;
        Thu, 16 Jul 2020 02:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com;
        s=default; t=1594865443;
        bh=AEVS6FARCeqmIOD4dOV3ZjxZYov8SUPADkze2QBtd2U=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VNGL71/4e3vOeqULNruQv6Eh42pbPLDrgKrXc6yP8FOVuueE07edPuE8Bkw4kmur9
         3rIZ/g7uyrx8vg2IPnIMNNqMap5pB2uAFQ9T/AIpE4swnA2aB2K56zTZlUfRlGBE2T
         B5x8vOq/f0wEQc/8RMQtMx/be5zzYzbTHFNMSi2c=
Subject: Re: [PATCH v6 5/5] KVM: MIPS: clean up redundant kvm_run parameters
 in assembly
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        pbonzini@redhat.com, chenhuacai@gmail.com
Cc:     kvm@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200623131418.31473-1-tianjia.zhang@linux.alibaba.com>
 <20200623131418.31473-6-tianjia.zhang@linux.alibaba.com>
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
Message-ID: <e447bb5c-8b83-dfb1-a293-f2e9e586c2ec@flygoat.com>
Date:   Thu, 16 Jul 2020 10:10:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200623131418.31473-6-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C21DF4013E
X-Spamd-Result: default: False [-0.10 / 10.00];
         ARC_NA(0.00)[];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         R_DKIM_ALLOW(0.00)[flygoat.com:s=default];
         RECEIVED_SPAMHAUS_PBL(0.00)[114.42.221.235:received];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         R_SPF_SOFTFAIL(0.00)[~all:c];
         RCPT_COUNT_FIVE(0.00)[6];
         ML_SERVERS(-3.10)[148.251.23.173];
         DKIM_TRACE(0.00)[flygoat.com:+];
         DMARC_POLICY_ALLOW(0.00)[flygoat.com,none];
         DMARC_POLICY_ALLOW_WITH_FAILURES(0.00)[];
         FREEMAIL_TO(0.00)[linux.alibaba.com,redhat.com,gmail.com];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:148.251.0.0/16, country:DE];
         RCVD_COUNT_TWO(0.00)[2];
         MID_RHS_MATCH_FROM(0.00)[];
         HFILTER_HELO_BAREIP(3.00)[148.251.23.173,1]
X-Rspamd-Server: mail20.mymailcheap.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



ÔÚ 2020/6/23 21:14, Tianjia Zhang Ð´µÀ:
> In the current kvm version, 'kvm_run' has been included in the 'kvm_vcpu'
> structure. For historical reasons, many kvm-related function parameters
> retain the 'kvm_run' and 'kvm_vcpu' parameters at the same time. This
> patch does a unified cleanup of these remaining redundant parameters.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Reviewed-by: Huacai Chen <chenhc@lemote.com>

Tested-by: Jiaxun Yang <jiaxun.yang@flygoat.com>

Can confirm it works on Loongson-3A4000.

Thanks!

> ---

-- 
- Jiaxun

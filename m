Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74B297AC420
	for <lists+kvm@lfdr.de>; Sat, 23 Sep 2023 19:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbjIWRmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 Sep 2023 13:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbjIWRmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 Sep 2023 13:42:09 -0400
Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7770E41;
        Sat, 23 Sep 2023 10:41:55 -0700 (PDT)
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
        by cmsmtp with ESMTP
        id jjWTqGVdqbK1Vk6deqmNLZ; Sat, 23 Sep 2023 17:41:55 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTPS
        id k6ddqpBMluHtrk6deqaNhR; Sat, 23 Sep 2023 17:41:54 +0000
X-Authority-Analysis: v=2.4 cv=B8eqbchM c=1 sm=1 tr=0 ts=650f2362
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=P7XfKmiOJ4/qXqHZrN7ymg==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=HvF037n1xESchLcPDVoA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H4JREhYHBOAGWkRiGPUdzLOI0Q+X9gKq6OB7uMuTe1I=; b=MFwqU9oovIy23L0FWzwPeiuZaF
        pOuzFavWPqSrM6dWy7o1Y102OD/SxZHV2NguGty0Zdk6ijy/u5VxQm3mOLdd4jZfMpBsSgXGc1/TG
        3uh1l09NQKqRtbVd55eU/2Xb8O0FSKR3drSQGF9JjMOXFNEZBuIMZ/sigDM1kbxCCmqcXmVBmqJHb
        Hi5j6CMi2zHOOISwg/FevzUW2Mu+X9u2WYbKSu3NCLuy6TNzt/RmQzpheTpQuCR+/oIvyG/QBB+up
        iXgHha4UIzczUEeiCGMK0HdlhPVDJXdfKf9/WrGUM5uHzaG0JMSf7ns8Hfjl8c9bgiTpjMYc+H/S2
        0v72OciQ==;
Received: from [94.239.20.48] (port=47370 helo=[192.168.1.98])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.96)
        (envelope-from <gustavo@embeddedor.com>)
        id 1qjy33-003ahi-1V;
        Sat, 23 Sep 2023 03:31:33 -0500
Message-ID: <e8ff2426-66dc-3357-da9f-af818720b2a0@embeddedor.com>
Date:   Sat, 23 Sep 2023 10:32:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: Annotate struct kvm_irq_routing_table with
 __counted_by
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
References: <20230922175121.work.660-kees@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230922175121.work.660-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 94.239.20.48
X-Source-L: No
X-Exim-ID: 1qjy33-003ahi-1V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.1.98]) [94.239.20.48]:47370
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGF3kEVF/oyazSLptLeNrd1xq+LRv8hO1SPGnakzayri52Nx7j0OVhQg/hWDNf4DGIle5O5+KUsCMtaRPEynMucx7ZgZ6hWmo7IRAzuV911/YZX+15r7
 IwbaoonIg5JQsnx7dl0lp4tf635Wo2PnjnhESuaeO3fw726wYotE4g5sKj4w7TMmNyGsq/JqahA4MLHLGoK+FWCM4GYqjitRAu32Mwp32MO9t+7ZIpBDhKqI
 KvPBHGcqsOuSHrfZ8LHqRripAi6YRNHHeA7/sp+zkNxnAv9xYd7MHKHkyLQAUaew
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/22/23 11:51, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct kvm_irq_routing_table.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
-- 
Gustavo

> ---
>   include/linux/kvm_host.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fb6c6109fdca..4944136efaa2 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -664,7 +664,7 @@ struct kvm_irq_routing_table {
>   	 * Array indexed by gsi. Each entry contains list of irq chips
>   	 * the gsi is connected to.
>   	 */
> -	struct hlist_head map[];
> +	struct hlist_head map[] __counted_by(nr_rt_entries);
>   };
>   #endif
>   

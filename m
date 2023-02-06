Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B40768C366
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbjBFQcA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:32:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjBFQb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:31:58 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5AFCA3E;
        Mon,  6 Feb 2023 08:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=STKGoMxckYgPErYVx6yFdSgSELSlqbOgHBPVdzHyyLs=; b=lnerxUi6lBbiYf2Y+UUhZbBPmJ
        +X6wfgD18WcGyRK12K1LGi+4u2IcH3COxGSJxKyTO3WhCyxZpFOTgyh7DkWwHA5SP9c7HFmRqz+sr
        prKxyMjd04dQ3MEnxDDqxcayOv+Wl8S54nGC3kQrkERKkDKxj8ir0u4aOvOaULqs1aLf/+3z9+9Yn
        FwyzCmM1YY3u1iVzvYXjALBg4F2LzqmvdtuPVvf8yxxhqVfVcTqFep+9sH73Pz+gVc4K2pKSv6a/b
        jvI1L8ldjX3siYx1CmI75FUrOA7K8r3lamLJCGiQJCQvPzOGqUqhmZnCGJ9rZjwBLZ9kqRLhsPIEE
        bDik9Tsg==;
Received: from [2601:1c2:d00:6a60::9526]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pP4P6-009KzI-Gj; Mon, 06 Feb 2023 16:31:40 +0000
Message-ID: <e76610ec-2efa-4333-1f6d-6072c1412d24@infradead.org>
Date:   Mon, 6 Feb 2023 08:31:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] Documentation: kvm: Correct spelling
Content-Language: en-US
To:     Deming Wang <wangdeming@inspur.com>, pbonzini@redhat.com,
        corbet@lwn.net
Cc:     kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230206091120.1618-1-wangdeming@inspur.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230206091120.1618-1-wangdeming@inspur.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2/6/23 01:11, Deming Wang wrote:
> We shuold use the replace thie.
> 
> Signed-off-by: Deming Wang <wangdeming@inspur.com>
> ---
>  Documentation/virt/kvm/api.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 1b1f721e3fd9..4e164d449906 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8193,7 +8193,7 @@ the KVM_XEN_ATTR_TYPE_RUNSTATE_UPDATE_FLAG attribute in the KVM_XEN_SET_ATTR
>  and KVM_XEN_GET_ATTR ioctls. This controls whether KVM will set the
>  XEN_RUNSTATE_UPDATE flag in guest memory mapped vcpu_runstate_info during
>  updates of the runstate information. Note that versions of KVM which support
> -the RUNSTATE feature above, but not thie RUNSTATE_UPDATE_FLAG feature, will
> +the RUNSTATE feature above, but not the RUNSTATE_UPDATE_FLAG feature, will
>  always set the XEN_RUNSTATE_UPDATE flag when updating the guest structure,
>  which is perhaps counterintuitive. When this flag is advertised, KVM will
>  behave more correctly, not using the XEN_RUNSTATE_UPDATE flag until/unless

How about these in the same file?

api.rst:581: virutal ==> virtual
api.rst:2725: excution ==> execution
api.rst:5207: asynchonous ==> asynchronous
api.rst:5666: thats ==> that's  [should just be "that"]
api.rst:7420: priveleged ==> privileged
api.rst:7838: compatibilty ==> compatibility
api.rst:8241: implmented ==> implemented

and this one:
halt-polling.rst:17: dependant ==> dependent

and there are more in the subdirectories there.

-- 
~Randy

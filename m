Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE9A53974B
	for <lists+kvm@lfdr.de>; Tue, 31 May 2022 21:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347513AbiEaTrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 May 2022 15:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347483AbiEaTrM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 May 2022 15:47:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AE9B1F8
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 12:47:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q123so8715043pgq.6
        for <kvm@vger.kernel.org>; Tue, 31 May 2022 12:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=YhC+hN49BuSzPA2eVA/U+rfjQum2PYL/Zemnrj3txh0=;
        b=FhMngP+h/QliKbg6XS8bp+cpEhNKyESg7EWr5+H4hY/gbY3FNqrhlm/dll7peYP7GT
         Uv3Tw3xiYKMIDT+AFnDYlkyG2udMgt/V71thYzb1cHkzIT1plDbOGQRmnFXHHEU4XTcg
         rRA/SS2DEXu8N1+QhdBn4DOnx6Adgx2dUSuA40QHDFEm3hTTJRF8/fhzs9WEHdxQdkU3
         myIzXNU50STTaLKoMLjsDUqK6U4LhDzO9iwItNPCaqOqUrEYA4ShoqTWIu709HDdShfg
         GkgMIrS5lTvPeNjYEC/uksKmjVeQyy18mT7QATDjrSuRdIK1FdlsMzUkiaz1N0jnvAMV
         8srw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=YhC+hN49BuSzPA2eVA/U+rfjQum2PYL/Zemnrj3txh0=;
        b=LjYFId1KM5a98SU/oX+kZgNQXqWxgUL5AOgCAxddumkaUYTGd+cGrEGVqgrYI6k61P
         moUHEtp56Ahp/1Av1hkZNUtuO/1qoF04G2Sp124JSEdGPCFTrH1StWBdawa9xxkCrILA
         YRreVvXpTwE9DfLqMn0R8OCRYE3A24tfD2YyzPdJKE8oJIHzNkSfudVh4RCpvhhVJzsu
         6sFRnhBPysjWsOeae/1o7JTXP2hGObA8cLwHoPBKVfRxcycbgY+4eYYmCMQwjpm3eXIR
         6FjXrO3bED6eEiNxKVVY13ktPGGBHky7GNnUQTzHJRZ/J7dEiQHdmhrq6HpT2JQr8Ily
         GcWw==
X-Gm-Message-State: AOAM533izxg5sPm0iw5ZAckyyCGhrwsHy8IYxTBu06wngFPO8Q80Elzb
        WtXVfi1ipl1+m4xLTX5dPWeKfg==
X-Google-Smtp-Source: ABdhPJy4qIorEF0xR242+k5TYE62Ryzupn+gQ6zveoRl/R0+HKvtWCf2fZxT8WQGDcjy25T3Y8vAaA==
X-Received: by 2002:a63:1543:0:b0:3fa:8e73:d7a5 with SMTP id 3-20020a631543000000b003fa8e73d7a5mr34189956pgv.160.1654026430233;
        Tue, 31 May 2022 12:47:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id m6-20020a635806000000b003c67e472338sm10741774pgb.42.2022.05.31.12.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 12:47:09 -0700 (PDT)
Date:   Tue, 31 May 2022 19:47:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: Add const to file_operations
Message-ID: <YpZwum3FHCJKnWIQ@google.com>
References: <20220530020857.2565-1-wangxiang@cdjrlc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220530020857.2565-1-wangxiang@cdjrlc.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 30, 2022, Xiang wangx wrote:
> Struct file_operations should normally be const.

Operative word being "should".  kvm_chardev_ops isn't constant because kvm_init()
modifies the "owner".  The same was true for kvm_vcpu_fops and kvm_vm_fops until
commit 70375c2d8fa3 ("Revert "KVM: set owner of cpu and vm file operations"").

So, this patch is both stale, and completely broken when applied against current
KVM as well as whatever old version of KVM it was generated with.

arch/x86/kvm/../../../virt/kvm/kvm_main.c:4873:37: error: conflicting type qualifiers for ‘kvm_chardev_ops’
 4873 | static const struct file_operations kvm_chardev_ops = {
      |                                     ^~~~~~~~~~~~~~~
arch/x86/kvm/../../../virt/kvm/kvm_main.c:120:31: note: previous declaration of ‘kvm_chardev_ops’ with type ‘struct file_operations’
  120 | static struct file_operations kvm_chardev_ops;
      |                               ^~~~~~~~~~~~~~~
arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘kvm_init’:
arch/x86/kvm/../../../virt/kvm/kvm_main.c:5777:31: error: assignment of member ‘owner’ in read-only object
 5777 |         kvm_chardev_ops.owner = module;
      |                               ^
  CC      arch/x86/events/intel/p6.o
make[3]: *** [scripts/Makefile.build:288: arch/x86/kvm/../../../virt/kvm/kvm_main.o] Error 1
make[2]: *** [scripts/Makefile.build:550: arch/x86/kvm] Error 2


> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  virt/kvm/kvm_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3f6d450355f0..7dc2433f1b01 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3550,7 +3550,7 @@ static int kvm_vcpu_release(struct inode *inode, struct file *filp)
>  	return 0;
>  }
>  
> -static struct file_operations kvm_vcpu_fops = {
> +static const struct file_operations kvm_vcpu_fops = {
>  	.release        = kvm_vcpu_release,
>  	.unlocked_ioctl = kvm_vcpu_ioctl,
>  	.mmap           = kvm_vcpu_mmap,
> @@ -4599,7 +4599,7 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>  }
>  #endif
>  
> -static struct file_operations kvm_vm_fops = {
> +static const struct file_operations kvm_vm_fops = {
>  	.release        = kvm_vm_release,
>  	.unlocked_ioctl = kvm_vm_ioctl,
>  	.llseek		= noop_llseek,
> @@ -4701,7 +4701,7 @@ static long kvm_dev_ioctl(struct file *filp,
>  	return r;
>  }
>  
> -static struct file_operations kvm_chardev_ops = {
> +static const struct file_operations kvm_chardev_ops = {
>  	.unlocked_ioctl = kvm_dev_ioctl,
>  	.llseek		= noop_llseek,
>  	KVM_COMPAT(kvm_dev_ioctl),
> -- 
> 2.36.1
> 

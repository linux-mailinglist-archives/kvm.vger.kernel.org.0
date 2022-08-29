Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3164F5A5464
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 21:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiH2TRa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 15:17:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiH2TR3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 15:17:29 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A62F861C8;
        Mon, 29 Aug 2022 12:17:29 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id r22so8556984pgm.5;
        Mon, 29 Aug 2022 12:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=e2Bgm9OtspYaGEdpfofzm7dZotUv9cfpH7zxqDCD4ds=;
        b=OKWUpvZGFX+3jTt6Li+A6q0QWx3+2HS81EOL3EhXEGT/Lx3y1h9lzpBCifPfT37i17
         L5dF6lw7mRzFeRj5MJhpzPtb6zi+Gvevx53R5mHTfDj1U8+9IKXuWZB/E0l2yp2O7yoM
         hrzshvD405lCpuxYTicSIMMMiX7g5u9uXGC8kPSTAPQ1FyZE5qmy0h51t73m2GpQpeiX
         7x+Cgfr9vSH5CbiGmDWVIV+HmYdHt+R3HlAYmoPdOK+ZFbybAGJ5wVRqZIn9IGgFvq8p
         ZlVrbEX31yEM40EdDDNckmDO7rtUS4JktD3oVu3eJr74D2xQOr5Tyb/d5QD3Ec0Y5r7Z
         0+mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=e2Bgm9OtspYaGEdpfofzm7dZotUv9cfpH7zxqDCD4ds=;
        b=lLAVFJ3rJh5FotwCsuO2w9WxXpivIKqHmHJR0JRdct9Y23r8wNedvFxBMQjbYMJYfn
         p56G6WeMden1Yz0vSruj89wK/cBAtL9AZoZh5T10xjA4OmZW9dLWov5DGIxj0B1aY4Ks
         Kdx4JRh9e103v4uyCP4Obec9Cuj9YWLlMBfL5Net51SJBrfnOkBemJ+s84xbXUgE94Xs
         vD3Ht4tJ8U/gNYVJNwlOcLm43ktJLZ/aUERGG2p7Ox5K54X60LztTP9cXprqG0a2VInW
         48epejIJuSdMjp8o2ewbRVvg96eZxheajZAnLjFC1Eul6uJn/pQqoxtezcK2z45TUK+m
         xFtA==
X-Gm-Message-State: ACgBeo1MNSzEoWcC91+7Fh1QmFaXRawDLPwLMNGER67bEvEURf4dKBTz
        b9C9QdCdXGiMJ0PmkLclYmw=
X-Google-Smtp-Source: AA6agR6Pq4CucQC/1Cj7srmpABJxDCvT2wwVFQ8PT+/642ImG6XOY0ZsQaZkZejqyXl88FSec/nWnw==
X-Received: by 2002:a63:8a44:0:b0:42b:351d:e309 with SMTP id y65-20020a638a44000000b0042b351de309mr14741408pgd.426.1661800648462;
        Mon, 29 Aug 2022 12:17:28 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id 199-20020a6300d0000000b00419ab8f8d2csm53107pga.20.2022.08.29.12.17.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 12:17:27 -0700 (PDT)
Date:   Mon, 29 Aug 2022 12:17:26 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [PATCH v8 022/103] KVM: TDX: Add place holder for TDX VM
 specific mem_enc_op ioctl
Message-ID: <20220829191726.GB2700446@ls.amr.corp.intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
 <2d65bd56a7ab8c0776f5c6b7c8481dd45ad96794.1659854790.git.isaku.yamahata@intel.com>
 <25e3ecd2-7038-5e3b-b826-0366aea899c9@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25e3ecd2-7038-5e3b-b826-0366aea899c9@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 29, 2022 at 12:07:55PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 7b497ed1f21c..067f5de56c53 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -73,6 +73,14 @@ static void vt_vm_free(struct kvm *kvm)
> >   		return tdx_vm_free(kvm);
> >   }
> > +static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
> > +{
> > +	if (!is_td(kvm))
> > +		return -ENOTTY;
> > +
> > +	return tdx_vm_ioctl(kvm, argp);
> > +}
> > +
> >   struct kvm_x86_ops vt_x86_ops __initdata = {
> >   	.name = "kvm_intel",
> > @@ -214,6 +222,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
> >   	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
> >   	.dev_mem_enc_ioctl = tdx_dev_ioctl,
> > +	.mem_enc_ioctl = vt_mem_enc_ioctl,
> 
> suggeust to align the interafce/function name style with the scop.
> 
> patch 21 and 27 have the scope in interafce names(dev / vcpu), may be
> clearer to use  vcpu_mem_enc_ioctl?

This is a matter of preference.  I intentionally chose to drop mem_enc part
because actually KVM_MEMORY_ENCRYPT_OP is abused for TDX or SEV(-SNP) specific
operation.  Subcommand for KVM_MEMORY_ENCRYPT_OP is not directly related to
memory encryption.  It should be KVM_CONFIDENTIAL_OP or something.
Unfortunately it's too late to rename it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

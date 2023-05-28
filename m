Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4987138B1
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 10:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjE1IRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 04:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjE1IRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 04:17:11 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD2C99;
        Sun, 28 May 2023 01:17:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1ae4baa77b2so14280915ad.2;
        Sun, 28 May 2023 01:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685261829; x=1687853829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8F7LdKEhwhvTKGwDLkjFFT9MkA/8t6WYBHnsvBbtLwo=;
        b=YQIkmpx8R14jx6I4mxy0Nim/eFRLs4mJ2kKrBUtY9l/azDRmeB3VgWx8pnQTxm9ZRj
         kkDz1iX8mScz7Wwy9FMbC3l9DQFC/pvqXpxrSgdiTMJY7boJNidiXB15EOHqm1RhbGHY
         fcSe2Ej/FknrfKP/DPFtW8/FZm09SY0urYrnsqLZ2ql4ky+eU+s8urwXMNbn9lHKdCi3
         AQFc/dy1zPayeWgpe9eFHSNNKDKdvteSePl8s3G8rhvyPRoHBJAf3hfLZpPW88NEm8Ma
         JqXqqu02AwaIifKh1fLj6cOg3akc2WjAj2auc22+GcEOLpbJQ3JxkYGBe37ATAN0v2Re
         a1mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685261829; x=1687853829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8F7LdKEhwhvTKGwDLkjFFT9MkA/8t6WYBHnsvBbtLwo=;
        b=XhKASp8I8CoLz6rQM3UCAaTGqwFB5Ce0Wbp+XpnAkiWPBrfTKxAi//iAh/ncfK5Bz8
         zhISLH77yCUEp5okXpTMtDt01un5Xil1DJIm1oFVDaQeB6BCBTJRgKpajdztZqb3y6Hu
         U+I+TvcSX+k71NRSQ/czeRv+dsCatOIY9B6nZyv2G6fkNPrlDpUogqKjWNsDaWB8nVtq
         +WbHuGSWrAZrltzJbWYeyJTj4nnGsT9Fzv+V9DRTn7lvxe51B9hFIuGdc/BFlwS87eKT
         5QDaEz/QaHIBoXLc6H8leRFVxy7qnnOvO6QdMNvyooPmz/Tas5Yy86A4JU5cTGcEIYyZ
         HQzw==
X-Gm-Message-State: AC+VfDxw9xsDg8sJNTJs3uXOwBCCa0W3uXXygGoY6k/JuCY01hPXHE5R
        XQSkhCGKqwmpB17trmy0aZ8=
X-Google-Smtp-Source: ACHHUZ6afMfTOyutEl+xYUo5qRofU4fDVk9K310ITZV+c1M54vkyri/JKVWnYW7Qa8PRGaP4OIJ5Fg==
X-Received: by 2002:a17:903:1250:b0:1ac:482e:ed4d with SMTP id u16-20020a170903125000b001ac482eed4dmr8916461plh.18.1685261829393;
        Sun, 28 May 2023 01:17:09 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e80800b001b02bd00c61sm1924711plg.237.2023.05.28.01.17.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 01:17:08 -0700 (PDT)
Date:   Sun, 28 May 2023 01:17:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wen, Qian" <qian.wen@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 019/113] KVM: TDX: create/destroy VM structure
Message-ID: <20230528081707.GB1234772@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <7c011a5c9dd92cfb9074297af22d132a4e57fd11.1678643052.git.isaku.yamahata@intel.com>
 <fd9359f2-f65b-745e-c984-b9c53a0f5ba1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fd9359f2-f65b-745e-c984-b9c53a0f5ba1@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 23, 2023 at 04:17:07PM +0800,
"Wen, Qian" <qian.wen@intel.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> > index 8118647aa8ca..8f87eeeab97c 100644
> > --- a/arch/x86/kvm/vmx/x86_ops.h
> > +++ b/arch/x86/kvm/vmx/x86_ops.h
> > @@ -139,19 +139,28 @@ void vmx_setup_mce(struct kvm_vcpu *vcpu);
> >  
> >  #ifdef CONFIG_INTEL_TDX_HOST
> >  int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops);
> > +void tdx_hardware_unsetup(void);
> >  int tdx_hardware_enable(void);
> >  bool tdx_is_vm_type_supported(unsigned long type);
> >  int tdx_dev_ioctl(void __user *argp);
> >  
> >  int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
> > +int tdx_vm_init(struct kvm *kvm);
> > +void tdx_mmu_release_hkid(struct kvm *kvm);
> > +void tdx_vm_free(struct kvm *kvm);
> >  int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
> >  #else
> >  static inline int tdx_hardware_setup(struct kvm_x86_ops *x86_ops) { return -ENOSYS; }
> > +static inline void tdx_hardware_unsetup(void) {}
> >  static inline int tdx_hardware_enable(void) { return -EOPNOTSUPP; }
> >  static inline bool tdx_is_vm_type_supported(unsigned long type) { return false; }
> >  static inline int tdx_dev_ioctl(void __user *argp) { return -EOPNOTSUPP; };
> >  
> >  static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap) { return -EINVAL; };
> > +static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
> > +static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
> > +static inline void tdx_flush_shadow_all_private(struct kvm *kvm) {}
> 
> typo? This function tdx_flush_shadow_all_private is not used anywhere.

Right. It was carry over from the old versions. Will remove the line.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

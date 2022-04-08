Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21CD64F8B03
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiDHAxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiDHAxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:53:19 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26AC4158DAC;
        Thu,  7 Apr 2022 17:51:18 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so10484941pjn.3;
        Thu, 07 Apr 2022 17:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dodW1fVEcct0O/JyTL9zJf6rBjh5DGa2iEPmEpDwu9E=;
        b=iGn315jREigICcuAlexjNs/dQW2YimHhkdZ6DFgrcVuZ5toRN1Q5rj2y9rBYzaGnNl
         wpaS21Gs9jPXTC4O/oE5jGfHUtOcHBoTB1Ld4Zj+FFLUvbEbYvhDXzktSETJ4gVy+xQq
         ptJneqDeE5zUFualS3xAcOSvLJ2bstW2ahzeUMO66oCKx5QyFoaauXrtKjrb8S19osBT
         mNcC4SuvCtFI00dC7+d341B6LLsNmzeZYqjhYBx37zjkKzRviwMhkGoEfvJxlHQU0417
         40Sbqjq6ksgVUqEI25ZAQhMn3bfqEmedthlaXeCexvuqSQcNw3zozAQOnUfJ+ACmHzCK
         RbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dodW1fVEcct0O/JyTL9zJf6rBjh5DGa2iEPmEpDwu9E=;
        b=eIr33VScwj5iVGsdDoxkjRWPV3l/vv4k5tFFlfQt6eZRJzLXfly582qHjGL5jKy9UL
         nbt8XlKkJPt8BCu4elDBhPl0Uf7d5syiAuRdrJ/B6KdA+iWJPNwnYdKFdLE2pX9hnQk4
         m6wyniLIMDswkTFDoELaqGwOQqAcXHpvp/+Ea2kQR/yXAFhZQ0f6ZOo0e1310PkUxoBN
         rvsbq2z1ZEYzEwhkNNuVcgJniO3pviu0JMibbK52isb33Ys2rQrsPi6jIy4hZ6HUDf/8
         rvT0NP+FLliCU1BiVhsclbOuCFU5v9IJauWHTv7GLcda8wR9RF1WzkN0S3QTeR6vndfo
         n3CA==
X-Gm-Message-State: AOAM533cIYSA4Qosmjs/2Qr/mTAmsZ434dkOf0aLVZ02DoPeRRBoEMZy
        YTRB5OmYGvfJa0+K1MItbeM=
X-Google-Smtp-Source: ABdhPJwOamlk6v0ZvDEDupwF3OT7hM5UbMEJcNWFFTXRHfhYhIgd0smW1kjGDTL4Y6IoQgs0sLOaNw==
X-Received: by 2002:a17:903:240c:b0:153:c452:f282 with SMTP id e12-20020a170903240c00b00153c452f282mr16186894plo.88.1649379077566;
        Thu, 07 Apr 2022 17:51:17 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b0050566040330sm4245426pfl.126.2022.04.07.17.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 17:51:17 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:51:16 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 024/104] KVM: TDX: create/destroy VM structure
Message-ID: <20220408005116.GB2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <36805b6b6b668669d5205183c338a4020df584dd.1646422845.git.isaku.yamahata@intel.com>
 <aa6afd32-8892-dc8d-3804-3d85dcb0b867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aa6afd32-8892-dc8d-3804-3d85dcb0b867@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 05, 2022 at 02:44:04PM +0200,
Paolo Bonzini <pbonzini@redhat.com> wrote:

> > diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> > index 6111c6485d8e..5c3a904a30e8 100644
> > --- a/arch/x86/kvm/vmx/main.c
> > +++ b/arch/x86/kvm/vmx/main.c
> > @@ -39,12 +39,24 @@ static int vt_vm_init(struct kvm *kvm)
> >   		ret = tdx_module_setup();
> >   		if (ret)
> >   			return ret;
> > -		return -EOPNOTSUPP;	/* Not ready to create guest TD yet. */
> > +		return tdx_vm_init(kvm);
> >   	}
> >   	return vmx_vm_init(kvm);
> >   }
> > +static void vt_mmu_prezap(struct kvm *kvm)
> > +{
> > +	if (is_td(kvm))
> > +		return tdx_mmu_prezap(kvm);
> > +}
> 
> Please rename the function to explain what it does, for example
> tdx_mmu_release_hkid.

In the patch 021/104,  you suggested flush_shadow_all_private().
Which do you prefer? flush_shadow_all_private or tdx_mmu_release_hkid.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>

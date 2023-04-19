Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275B66E778C
	for <lists+kvm@lfdr.de>; Wed, 19 Apr 2023 12:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbjDSKi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Apr 2023 06:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232063AbjDSKi4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Apr 2023 06:38:56 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58A1C2;
        Wed, 19 Apr 2023 03:38:54 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2a7ffe75ae4so3462461fa.0;
        Wed, 19 Apr 2023 03:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681900733; x=1684492733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFeUeRReVqfmHEBFJNhWwM8mC6IxbLrqFkqgC+66KY0=;
        b=o2j8eQePFP0WspOBIHEnCLVLE6n8IoPl76B1gSVGkYMhCtZOxc9FfY8eShIqd0A5Rs
         Da8rcyjwOZNhbplSHKfR1wIwNG9eB6D79aeWwDAbbS2ZY/TlwaoC81czCFoPWv9YuDEE
         4L1z4cptotUnB4O0pqIpm4zpaslaYjnJ0YD65haubOLRKgchUcSiTRTCNSnHqbg1MP+G
         IaK8ZqkyjLCrbhQ9+VgfjNw6RhN8I3/1FjvNLSTWG1J+5QqCsi93ARP8Os/YW97JqgNJ
         2T7QWsgXbomAjdHh1qVEy/jjzc1ODGSBNfRGDzY5CrPZIxwah12w58P4XNg6tT2wAMlm
         eprQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681900733; x=1684492733;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iFeUeRReVqfmHEBFJNhWwM8mC6IxbLrqFkqgC+66KY0=;
        b=lHUrbQ5byjEXMClUSNgg8SjTSTg3kn3ioRoFxmtri66/IkqmEg3uR/w3jNEcXJeyhA
         HS/qHukr0/80uaPhZ6KCiStfHlcH8VAoSpfzHoRizj7XIfNzjY+i3jTk5NWELCLDzbOB
         HG29ogxTas4ePd3sb+zg/2v3YwrIlI8LCxgAz0wlbEPqTS0prQfyc07O4xkhWPglJ2Rz
         OH53jlaqMNEd1LUXzzjeKW/InBR8wo2j9/C6HAx3dW6REv1tVjQFhmaWFhVgzTU1lmcz
         IiPMkjIXgexVa+I4vqRhkewTUzPPo2br/GfDmvmHy6c+mhhxMnMd2QoAx9bNbRVwGbT7
         AEFw==
X-Gm-Message-State: AAQBX9fu4iil1IWKjhc95FcZb8mFHsYegu1E4yw51ZsJT0G0NiXZ+huk
        1KJuvQ4LkP/hGYwnA/CzslM=
X-Google-Smtp-Source: AKy350aMnAtct5UxyWYcOOfzUoo5NBZZ5SBvhkNojgr+2C7G2wtKfGsdhjdUh1o6IJqzgw28cDG5hw==
X-Received: by 2002:ac2:42c5:0:b0:4e7:ed3c:68ea with SMTP id n5-20020ac242c5000000b004e7ed3c68eamr3780079lfl.5.1681900732797;
        Wed, 19 Apr 2023 03:38:52 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id 7-20020ac25687000000b004edc2a023ffsm1220704lfr.36.2023.04.19.03.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 03:38:52 -0700 (PDT)
Date:   Wed, 19 Apr 2023 13:38:41 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Vishal Annapurve <vannapurve@google.com>
Cc:     isaku.yamahata@intel.com, dmatlack@google.com,
        erdemaktas@google.com, isaku.yamahata@gmail.com,
        kai.huang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        sagis@google.com, seanjc@google.com
Subject: Re: [PATCH v13 098/113] KVM: TDX: Handle TDX PV map_gpa hypercall
Message-ID: <20230419133841.00001ee8.zhi.wang.linux@gmail.com>
In-Reply-To: <20230418190904.1111011-1-vannapurve@google.com>
References: <c49aa7b7bbc016b6c8b698ac2ce3b9d866b551f9.1678643052.git.isaku.yamahata@intel.com>
        <20230418190904.1111011-1-vannapurve@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 18 Apr 2023 19:09:04 +0000
Vishal Annapurve <vannapurve@google.com> wrote:

> > +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	gpa_t gpa = tdvmcall_a0_read(vcpu);
> > +	gpa_t size = tdvmcall_a1_read(vcpu);
> > +	gpa_t end = gpa + size;
> > +
> > +	if (!IS_ALIGNED(gpa, PAGE_SIZE) || !IS_ALIGNED(size, PAGE_SIZE) ||
> > +	    end < gpa ||
> > +	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> > +	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
> > +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> > +		return 1;
> > +	}
> > +
> > +	return tdx_vp_vmcall_to_user(vcpu);
> 
> This will result into exits to userspace for MMIO regions as well. Does it make
> sense to only exit to userspace for guest physical memory regions backed by
> memslots?
> 
I think this is necessary as when passing a PCI device to a TD, the guest needs to convert a MMIO region from private to shared, which is not backed by memslots.
> > +}
> > +


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE684E5B35
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 23:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344631AbiCWWYT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 18:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239488AbiCWWYT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 18:24:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3ECD89CEB
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:22:48 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d19so2503820pfv.7
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 15:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yuhCT1XYYGgw1dNBRxPY3XRz8+9xX+vJlVURnfEK72s=;
        b=a6UMluZevPKT+3Dg9RSgS2V8HA5VIKtIYAYHNtZAilzCYPLEkP61tf7mwIeq9BnxHV
         X0SgovhpKa/+gqiVJN6lWUp1uqPIgn+vMHpzy4VXM3c5yJiRCCC7UOKbGbnjbjkhLAE7
         RHoBAkQ9xUgD9dL1xMdBPTjxKpnSLtsHOUrHXa/tPYiz85ecbU2IYJE4lBhgWY8zKwGF
         vqpuZjlGklfvuQhQrNXTf+r2eBpbhmqcZmGyDOFQNN46b1i50uXvRmRLSPk2NVi2GwpT
         8vFYEZYuHVzaBo1/gI+EK2Y8aj0KQFDtW7xPe3JsxzKdlPYgnKKD2PAnzmnuMs1FyqJE
         PHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yuhCT1XYYGgw1dNBRxPY3XRz8+9xX+vJlVURnfEK72s=;
        b=QZa1ogLDnILV9OKgOn0JrmulrebxMOEtk2PsqnOlm043o5jmnnJkJVoGFaJJhkl1DE
         rmjaXcSL59PEnHhEjBe4GIkBhBK7CDEZuDcSfC+i8H7dTfCSY1kYjcMEdjCh6rkedKfX
         hSzGRpauiA9WzYEiTKS7jwqdzJhegQjwmg+rZSh3Ah8NN/XlYXwzsbq5aHQRghY3mf8n
         Mi6QOwtpZZ0OT1ddgNahxE7lSeaX38TM1wHLZc41MmoalEShwUj40bvjXKT4EA5oK0Gh
         k353nP30blSC4Q7MA/gJsRU/dvYBQAMsauZv7h5ix19jtr/hTAUs4KVxHqIIp8+eohcT
         ZUMA==
X-Gm-Message-State: AOAM533Bkq8bG4mjHAA8TsV4mR1RGEqC3ojzxOSFyZ6BGykQI/YnEZ7F
        l9whZzIBKDg8BuMNhUBxdeXgsw==
X-Google-Smtp-Source: ABdhPJzfVU2lcXkwbXmRJ0QbmK41CUoL1lq9MqK1Ux1D5KLG5O0S8v51famIcyUnsJNrUX/Wy/YeJQ==
X-Received: by 2002:a63:7f0e:0:b0:381:54ca:6fd0 with SMTP id a14-20020a637f0e000000b0038154ca6fd0mr1631352pgd.524.1648074167926;
        Wed, 23 Mar 2022 15:22:47 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id fy9-20020a17090b020900b001c690bc05c4sm675504pjb.0.2022.03.23.15.22.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:22:47 -0700 (PDT)
Date:   Wed, 23 Mar 2022 15:22:43 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Reiji Watanabe <reijiw@google.com>, Marc Zyngier <maz@kernel.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Subject: Re: [PATCH v6 11/25] KVM: arm64: Add remaining ID registers to
 id_reg_desc_table
Message-ID: <Yjuds73S1sO1UpJI@google.com>
References: <20220311044811.1980336-1-reijiw@google.com>
 <20220311044811.1980336-12-reijiw@google.com>
 <Yjt6qvYliEDqzF9j@google.com>
 <Yjt/bJidLEPsiPfQ@google.com>
 <YjuGqunshjhCoIs5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjuGqunshjhCoIs5@google.com>
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

On Wed, Mar 23, 2022 at 08:44:26PM +0000, Oliver Upton wrote:
> On Wed, Mar 23, 2022 at 01:13:32PM -0700, Ricardo Koller wrote:
> > On Wed, Mar 23, 2022 at 07:53:14PM +0000, Oliver Upton wrote:
> > > Hi Reiji,
> > > 
> > > On Thu, Mar 10, 2022 at 08:47:57PM -0800, Reiji Watanabe wrote:
> > > > Add hidden or reserved ID registers, and remaining ID registers,
> > > > which don't require special handling, to id_reg_desc_table.
> > > > Add 'flags' field to id_reg_desc, which is used to indicates hiddden
> > > > or reserved registers. Since now id_reg_desc_init() is called even
> > > > for hidden/reserved registers, change it to not do anything for them.
> > > > 
> > > > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > > 
> > > I think there is a very important detail of the series that probably
> > > should be highlighted. We are only allowing AArch64 feature registers to
> > > be configurable, right? AArch32 feature registers remain visible with
> > > their default values passed through to the guest. If you've already
> > > stated this as a precondition elsewhere then my apologies for the noise.
> > 
> > Aren't AArch64 ID regs architecturally mapped to their AArch32
> > counterparts?  They should show the same values.  I'm not sure if it's a
> > problem (and if KVM is faithful to that rule),
> 
> I believe it's a bit more subtle than that. The AArch32 feature registers
> are architecturally mapped to certain encodings accessible from AArch64.
> For example, ID_PFR0_EL1 is actually a 64 bit register where bits [31:0]
> map to the ID_PFR0 AArch32 register. ID_PFR0_EL1 is only accessible from
> AArch64 with the MRS instruction, and ID_PFR0 is only accessible from
> AArch32 with the MRC instruction. KVM just so happens to handle both of
> these reads from the same sys_reg_desc.
> 
> AFAIK, there does not exist a direct bit mapping between the
> ID_*_EL1 <-> ID_AA64*_EL1 registers. But hey, could be wrong :)

I think you are right. ID_PFR0_EL1[31:0] doesn't even have the same
field as ID_AA64PFR0_EL1[31:0]. The only exception would be RAS which is
at [31:28] on both, but it doesn't say anywhere that ID_PFR0_EL1.RAS
maps architecturally to ID_AA64PFR0_EL1.RAS. So, I think we can assume
it doesn't (?).

Thanks,
Ricardo

> 
> --
> Thanks,
> Oliver

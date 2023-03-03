Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A076A9686
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 12:39:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjCCLjN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 06:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCCLjM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 06:39:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6E2C86A2;
        Fri,  3 Mar 2023 03:39:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64870617BF;
        Fri,  3 Mar 2023 11:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B587C433D2;
        Fri,  3 Mar 2023 11:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677843550;
        bh=kU/Ch3/h5WcXNFnEIJI+X3pPxVuYNKbYP9iG0kOs07M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MHkKMOpSsP/RYBqZ9Fn4cYK/Fwxrm1sEttxqN+9L35DKC0l44kt49MFCy92c+JGNI
         YbtDqlsq+YY4UyglC7hPlYfBMnPTfBQOTbAKSO+Vq7KgvUM4ZkrGDiFAi7OLEnyT8H
         Tutc+D7uCjbiDzpzrKEm2ZcVuzTRzXLUa/WYAma+jJ23YdgTPbFi56C5VnyEt5PT7d
         ZPgcD/IfThxtcNMEwAUM/NKjy4Vxh0cxoPtya0TGeCp+dtl/S3J6RNzTonW4VYhm3A
         UdSuakGNZ8RfETRkwiWzz2s7+VQQ8gNU/T2Od7TSwkOlvWYbl8QUNd7bcm/K9mAK//
         2HotVVtQW0q1g==
Date:   Fri, 3 Mar 2023 11:39:05 +0000
From:   Jean-Philippe Brucker <jpb@kernel.org>
To:     Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Itaru Kitayama <itaru.kitayama@gmail.com>,
        linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Message-ID: <20230303113905.GD361458@myrica>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
 <20230303094618.GC361458@myrica>
 <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 09:54:47AM +0000, Suzuki K Poulose wrote:
> On 03/03/2023 09:46, Jean-Philippe Brucker wrote:
> > On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
> > > > > I've tried your series in Real on CCA Host, but the KVM arch init
> > > > > emits an Invalid argument error and terminates.
> > 
> > This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
> > didn't enable SVE in the host but shrinkwrap enables more options.
> 
> Does the Qemu check for SVE capability on /dev/kvm ? For kvmtool, we
> changed to using the VM instance and that would prevent using SVE,
> until the RMM supports it.

Yes, QEMU does check the SVE cap on /dev/kvm. I can propose changing it or
complementing it with a VM check in my next version, it seems to work
(though I need to double-check the VM fd lifetime). Same goes for
KVM_CAP_STEAL_TIME, which I need to disable explicitly at the moment.

Thanks,
Jean

> 
> Suzuki
> 
> > 
> > Until we figure out support for SVE, disable it on the QEMU command-line
> > (similarly to '--disable-sve' needed for kvmtool boot):
> > 
> > 	-cpu host,sve=off
> > 
> > Thanks,
> > Jean
> 
> 

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB956A948D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 10:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCCJzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 04:55:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbjCCJy5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 04:54:57 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1702B1204A;
        Fri,  3 Mar 2023 01:54:52 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F9C62F4;
        Fri,  3 Mar 2023 01:55:35 -0800 (PST)
Received: from [10.57.90.45] (unknown [10.57.90.45])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9ED7B3F587;
        Fri,  3 Mar 2023 01:54:48 -0800 (PST)
Message-ID: <1c91b777-982e-e71a-4829-51744e9555c5@arm.com>
Date:   Fri, 3 Mar 2023 09:54:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Itaru Kitayama <itaru.kitayama@gmail.com>
Cc:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
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
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <Y9PtKJ3Wicc19JF1@myrica>
 <CANW9uyud8RTkqgiL=64wV712QMxtAyubqeyCJ0vpcADJ42VqJA@mail.gmail.com>
 <Y/8Y3WLmiw6+Z5AS@myrica>
 <CANW9uysnvGCwANu+_6dp9+3rvHGOkThT9d0K2qpQV4exdmYWoA@mail.gmail.com>
 <20230303094618.GC361458@myrica>
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20230303094618.GC361458@myrica>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/2023 09:46, Jean-Philippe Brucker wrote:
> On Thu, Mar 02, 2023 at 07:12:24AM +0900, Itaru Kitayama wrote:
>>>> I've tried your series in Real on CCA Host, but the KVM arch init
>>>> emits an Invalid argument error and terminates.
> 
> This was the KVM_SET_ONE_REG for the SVE vector size. During my tests I
> didn't enable SVE in the host but shrinkwrap enables more options.

Does the Qemu check for SVE capability on /dev/kvm ? For kvmtool, we
changed to using the VM instance and that would prevent using SVE,
until the RMM supports it.

Suzuki

> 
> Until we figure out support for SVE, disable it on the QEMU command-line
> (similarly to '--disable-sve' needed for kvmtool boot):
> 
> 	-cpu host,sve=off
> 
> Thanks,
> Jean


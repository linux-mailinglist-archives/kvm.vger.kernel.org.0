Return-Path: <kvm+bounces-5996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A3A829B8F
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 14:45:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2D37283DDD
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 13:45:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D393848CC9;
	Wed, 10 Jan 2024 13:44:54 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DADD48CC1;
	Wed, 10 Jan 2024 13:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 083E62F4;
	Wed, 10 Jan 2024 05:45:37 -0800 (PST)
Received: from [10.57.46.83] (unknown [10.57.46.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 438EE3F64C;
	Wed, 10 Jan 2024 05:44:47 -0800 (PST)
Message-ID: <d47e8b8c-50e4-4ad3-8f00-cadaede1eca9@arm.com>
Date: Wed, 10 Jan 2024 13:44:45 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] Support for Arm CCA VMs on Linux
Content-Language: en-GB
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev, catalin.marinas@arm.com, will@kernel.org,
 maz@kernel.org, steven.price@arm.com, alexandru.elisei@arm.com,
 joey.gouly@arm.com, james.morse@arm.com, Jonathan.Cameron@huawei.com,
 dgilbert@redhat.com, jpb@kernel.org, oliver.upton@linux.dev,
 zhi.wang.linux@gmail.com, yuzenghui@huawei.com, salil.mehta@huawei.com,
 Andrew Jones <andrew.jones@linux.dev>,
 Chao Peng <chao.p.peng@linux.intel.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Mark Rutland <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Quentin Perret <qperret@google.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Huth <thuth@redhat.com>,
 Ryan Roberts <Ryan.Roberts@arm.com>, Sami Mujawar <Sami.Mujawar@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20231002124311.204614-1-suzuki.poulose@arm.com> <ZZ4tsTQOKOamM+h/@vm3>
 <ec8ed5b0-5080-45e9-a4a6-e5dbe48e86d3@arm.com>
In-Reply-To: <ec8ed5b0-5080-45e9-a4a6-e5dbe48e86d3@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/01/2024 11:41, Suzuki K Poulose wrote:
> Hi Itaru,
> 
> On 10/01/2024 05:40, Itaru Kitayama wrote:
>> On Mon, Oct 02, 2023 at 01:43:11PM +0100, Suzuki K Poulose wrote:
>>> Hi,
>>>
>>>

...

>>
>> Suzuki,
>> Any update to the Arm CCA series (v3?) since last October?
> 
> Yes, we now have a version that supports the final RMM-v1.0
> specification (RMM-v1.0-EAC5). We also have the UEFI EDK2 firmware
> support for Guests in Realm world.
> 
> We are planning to post the changes for review in the v6.8-rc cycle. We
> are trying to integrate the guest_mem support (available in v6.8-rc1) as
> well as reusing some of the arm64 kvm generic interface for configuring
> the Realm parameters (e.g., PMU, SVE_VL etc).
> 
> Here is a version that is missing the items mentioned above, based
> on v6.7-rc4, if anyone would like to try.
> 
> Also, the easiest way to get the components built and model kick started
> is using the shrinkwrap [6] tool, using the cca-3world configuration.
> The tool pulls all the required software components, builds (including
> the buildroot for rootfs) and can run a model using these built
> components.

Also, please see 'arm/run-realm-tests.sh' in the kvm-unit-tests-cca 
repository for sample command lines to invoke kvmtool to create Realm
VMs.


> 
> 
> 
> [0] Linux Repo:
>        Where: git@git.gitlab.arm.com:linux-arm/linux-cca.git
>        KVM Support branch: cca-host/rmm-v1.0-eac5
>        Linux Guest branch: cca-guest/rmm-v1.0-eac5
>        Full stack branch:  cca-full/rmm-v1.0-eac5
> 
> [1] kvmtool Repo:
>        Where: git@git.gitlab.arm.com:linux-arm/kvmtool-cca.git
>        Branch: cca/rmm-v1.0-eac5
> 
> [2] kvm-unit-tests Repo:
>        Where: git@git.gitlab.arm.com:linux-arm/kvm-unit-tests-cca.git
>        Branch: cca/rmm-v1.0-eac5
> 
> [3] UEFI Guest firmware:
>        edk2:     https://git.gitlab.arm.com/linux-arm/edk2-cca.git
>        revision: 2802_arm_cca_rmm-v1.0-eac5
> 
>        edk2-platforms: 
> https://git.gitlab.arm.com/linux-arm/edk2-platforms-cca.git
>        revision:       2802_arm_cca_rmm-v1.0-eac5
> 
> 
> [4] RMM Repo:
>        Where: https://git.trustedfirmware.org/TF-RMM/tf-rmm.git
>        tag : tf-rmm-v0.4.0
> 
> [5] TF-A repo:
>        Where: https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git
>        Tag: v2.10
> 
> 
> [6] https://shrinkwrap.docs.arm.com/en/latest/
>      config: cca-3world.yaml
> 

Suzuki



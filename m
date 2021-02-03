Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199A930E58B
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 23:04:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbhBCWDk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 17:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhBCWDV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Feb 2021 17:03:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269BC64F4E;
        Wed,  3 Feb 2021 22:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612389760;
        bh=vsAzWk/StcrZ8hocjbqqlzYkIKuUbYgVwwBOckEK9po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MQlWDKOMGq39vuuVH/a2D2ksgAVwTgOFKGmraWnb+FCKxP/grwoHP/iMwRaEWqjUo
         8cEd/oQuHqep/v0inIMCUvstpDw4Ob/LCrwxVN0RX7FOucC4PFxi0WBQqpi/THBqzT
         b8J4C79Uak/BQpNAAgYqQD0uhCGZp0KWFopY2l6/0izFr72oXJ+3AGJxg+pwh1sPfs
         6f73WSehEryHJQJzRGTjcg0oUOGtGzY+fIEXj9YHt57OxMKD7F9B1McFhhUtGKMfTd
         6ZV73o8h2aY+tMYUeno4UoSE1vOG4DHGBK/xXn2UE1Ty/BVFw7FVZEhdlQSyTge0jM
         GMg1IK3PECCGw==
Date:   Thu, 4 Feb 2021 00:02:33 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 08/27] x86/sgx: Initialize virtual EPC driver even
 when SGX driver is disabled
Message-ID: <YBsdeco/t8sa7ecV@kernel.org>
References: <cover.1611634586.git.kai.huang@intel.com>
 <5076ed2c486ac33bfd87dc0e17047a1673692b53.1611634586.git.kai.huang@intel.com>
 <YBVxF2kAl7VzeRPS@kernel.org>
 <20210201184040.646ea9923c2119c205b3378d@intel.com>
 <YBmMrqxlTxClg9Eb@kernel.org>
 <YBmX/wFFshokDqWM@google.com>
 <YBndRM9m0XHYwsPP@kernel.org>
 <20210203134906.78b5265502c65f13bacc5e68@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203134906.78b5265502c65f13bacc5e68@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021 at 01:49:06PM +1300, Kai Huang wrote:
> What working *incorrectly* thing is related to SGX virtualization? The things
> SGX virtualization requires (basically just raw EPC allocation) are all in
> sgx/main.c. 

States:

A. SGX driver is unsupported.
B. SGX driver is supported and initialized correctly.
C. SGX driver is supported and failed to initialize.

I just thought that KVM should support SGX when we are either in states A
or B.  Even the short summary implies this. It is expected that SGX driver
initializes correctly if it is supported in the first place. If it doesn't,
something is probaly seriously wrong. That is something we don't expect in
a legit system behavior.

/Jarkko

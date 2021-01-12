Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE9C2F2615
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 03:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbhALCIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 21:08:45 -0500
Received: from mga04.intel.com ([192.55.52.120]:30909 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbhALCIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jan 2021 21:08:44 -0500
IronPort-SDR: Y6IGrWOxPA23pDtEPqThFXcSGumA/HxcgLRf0hJeSxR0dNpJvjgE2I7eLrL0UtD6eWKPjoQ8Mc
 QO3diSIRXaEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9861"; a="175388174"
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="175388174"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:08:02 -0800
IronPort-SDR: pBUVGzuPoEV51Z+y+cy/1aj9XGB2p7Sr2rmHd8b2zOWZtqUnrDzt9aSzXJh3k47V5EKBN0N2hb
 nCX2AX9lcgzA==
X-IronPort-AV: E=Sophos;i="5.79,340,1602572400"; 
   d="scan'208";a="352829883"
Received: from tpotnis-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.76.146])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2021 18:07:58 -0800
Date:   Tue, 12 Jan 2021 15:07:56 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, mattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
Message-Id: <20210112150756.f3fb039ac1bb176262da5e52@intel.com>
In-Reply-To: <X/0DRMx7FC5ssg0p@kernel.org>
References: <cover.1609890536.git.kai.huang@intel.com>
        <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
        <20210112141428.038533b6cd5f674c906a3c43@intel.com>
        <X/0DRMx7FC5ssg0p@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> > > > 
> > > > To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> > > > core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> > > > "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX driver,
> > > > virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave associated,
> > > > and how virtual EPC is used by guest is compeletely controlled by guest's SGX
> > > > software.
> > > 
> > > I think that /dev/sgx_vepc would be a clear enough name for the device. This
> > > text has now a bit confusing "terminology" related to this.
> > 
> > /dev/sgx_virt_epc may be clearer from userspace's perspective, for instance,
> > if people see /dev/sgx_vepc, they may have to think about what it is,
> > while /dev/sgx_virt_epc they may not.
> > 
> > But I don't have strong objection here. Does anyone has anything to say here?
> 
> It's already an abberevation to start with, why leave it halfways?
> 
> Especially when three remaining words have been shrunk to single
> characters ('E', 'P' and 'C').
> 

I have expressed my opinion above. And as I said I don't have strong objection
here. I'll change to /dev/sgx_vepc if no one opposes.

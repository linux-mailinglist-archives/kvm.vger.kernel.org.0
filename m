Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951CF343D6A
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 11:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhCVKDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 06:03:44 -0400
Received: from mga06.intel.com ([134.134.136.31]:26041 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhCVKDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 06:03:36 -0400
IronPort-SDR: ETFuzQAPFEbSVhWJXxB9Y+w0LR3VAz12wz8wQbF5A1yY+yeK58LVphG6wIiZ285574EQt/kepR
 4RJC0Fcuy6Fg==
X-IronPort-AV: E=McAfee;i="6000,8403,9930"; a="251593999"
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="251593999"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 03:03:35 -0700
IronPort-SDR: +bT4eNAUlnvHiNxoIKm/o8CmhiCLdRep513I5wu/BZ7FyMAwZWhP2mmsdhM9BXLoDS1EJ5psj+
 QTEbNajHwycQ==
X-IronPort-AV: E=Sophos;i="5.81,268,1610438400"; 
   d="scan'208";a="414423453"
Received: from zssigmon-mobl.amr.corp.intel.com ([10.254.92.253])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 03:03:30 -0700
Message-ID: <d876e5abb1a7e4fce160bfcb217bf3ab675f44a8.camel@intel.com>
Subject: Re: [PATCH v3 00/25] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, seanjc@google.com, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Date:   Mon, 22 Mar 2021 23:03:28 +1300
In-Reply-To: <YFS6kTe1SuAjiMFN@kernel.org>
References: <cover.1616136307.git.kai.huang@intel.com>
         <YFS6kTe1SuAjiMFN@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> I just say add my ack to SGX specific patches where it is missing.
> Good enough.
> 
> /Jarkko

Thank you Jarkko!

Hi Boris,

If there's no other comments, should I send another version adding Jarkko's Acked-by
for the x86 SGX patches that don't have it (patch 2, 5, 6, 7, 8, 13 -- in which patch
2 and 6 are changes to generic x86)?



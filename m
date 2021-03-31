Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6651B34FBFB
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 10:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhCaIyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 04:54:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:12573 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234519AbhCaIxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 04:53:51 -0400
IronPort-SDR: 2P39R65TkXVRbemtAZ3fh4L3gxwoD0LqwhDLrIVo1ecUiLoPCOItCEHJpedQle6yWm6M7IrRxJ
 6GuOSaNHpe3g==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="277135452"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="277135452"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 01:53:50 -0700
IronPort-SDR: WeRnFS6jgJiJDuvdm6IgUzJh+9zCe1khGfh4s0adCb3r6x4gQy/mO0/mZMcJlQ2Dz8TqICzNtT
 29FuOSxV7voA==
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="455391755"
Received: from mwamucix-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.24.224])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 01:53:47 -0700
Date:   Wed, 31 Mar 2021 21:53:45 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Boris Petkov <bp@alien8.de>
Cc:     seanjc@google.com, kvm@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        jarkko@kernel.org, luto@kernel.org, dave.hansen@intel.com,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210331215345.cad098cfcfcaabf489243807@intel.com>
In-Reply-To: <3889C4C6-48E2-4C97-A074-180EB18BDA29@alien8.de>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210326150320.GF25229@zn.tnic>
        <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
        <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
        <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
        <3889C4C6-48E2-4C97-A074-180EB18BDA29@alien8.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 09:44:39 +0200 Boris Petkov wrote:
> On March 31, 2021 8:51:38 AM GMT+02:00, Kai Huang <kai.huang@intel.com> wrote:
> >How about adding explanation to Documentation/x86/sgx.rst?
> 
> Sure, and then we should point users at it. The thing is also indexed by search engines so hopefully people will find it.

Thanks. Will do and send out new patch for review.


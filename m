Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C993427AE
	for <lists+kvm@lfdr.de>; Fri, 19 Mar 2021 22:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCSVZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Mar 2021 17:25:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:11303 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhCSVZh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Mar 2021 17:25:37 -0400
IronPort-SDR: sqeCoVUt9kqxZ7JLx0S40s7xcYaY3kztw9W+BJVQuAdqBfaweH4O2aN3kn9mgSvVvbQd1kxdbJ
 xqV72hDiRpvA==
X-IronPort-AV: E=McAfee;i="6000,8403,9928"; a="169905272"
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="169905272"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:25:37 -0700
IronPort-SDR: Z+1iCkBSV/Zr3fu8bmAt+yHfly0Mpl/R4mXVrn4UyBtYx6nxw3ANHL60CqhidTEfGCdas6xCg1
 eYOxXYfBn++w==
X-IronPort-AV: E=Sophos;i="5.81,262,1610438400"; 
   d="scan'208";a="389774044"
Received: from jacob-builder.jf.intel.com (HELO jacob-builder) ([10.7.199.155])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 14:25:37 -0700
Date:   Fri, 19 Mar 2021 14:28:01 -0700
From:   Jacob Pan <jacob.jun.pan@intel.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <20210319142801.7dcce403@jacob-builder>
In-Reply-To: <20210304231946.2766648-2-vipinsh@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
        <20210304231946.2766648-2-vipinsh@google.com>
Organization: OTC
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vipin,

On Thu,  4 Mar 2021 15:19:45 -0800, Vipin Sharma <vipinsh@google.com> wrote:

> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Miscellaneous cgroup controller.
> + *
> + * Copyright 2020 Google LLC
> + * Author: Vipin Sharma <vipinsh@google.com>
> + */
> +#ifndef _MISC_CGROUP_H_
> +#define _MISC_CGROUP_H_
> +
nit: should you do #include <linux/cgroup.h>?
Otherwise, css may be undefined.

> +/**
> + * Types of misc cgroup entries supported by the host.
> + */

Thanks,

Jacob

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C36A8191813
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 18:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727650AbgCXRrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 13:47:36 -0400
Received: from mga17.intel.com ([192.55.52.151]:51824 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbgCXRrg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 13:47:36 -0400
IronPort-SDR: EroJeWM1GSU6O0nw+pToeQpaFecXktvrz7bevrCx0XGcYGuoBLqgE2NDX+l1piqiO6rLISYmQQ
 10fHSqMl+0Hw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 10:47:35 -0700
IronPort-SDR: /Dba8g1Ev7Mt3HAEAox+SqruuocqzRX7jLtMhq7XVwvIcFQbFonm31L4t/247hd6XIYy1CqKRg
 NWEL4XlR62kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,301,1580803200"; 
   d="scan'208";a="240115983"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga008.fm.intel.com with ESMTP; 24 Mar 2020 10:47:35 -0700
Date:   Tue, 24 Mar 2020 10:47:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v6 0/8] x86/split_lock: Fix and virtualization of split
 lock detection
Message-ID: <20200324174735.GC5998@linux.intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 24, 2020 at 11:18:51PM +0800, Xiaoyao Li wrote:
> So sorry for the noise that I forgot to CC the maillist.

You also forgot to add RESEND :-)  Tagging the patches like so

  [PATCH RESEND v6 0/8] x86/split_lock: Fix and virtualization of split lock detection

lets folks that received the originals identify and respond to the "new"
thread.

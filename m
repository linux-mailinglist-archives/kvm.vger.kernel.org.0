Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762711043E1
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 20:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfKTTEk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Wed, 20 Nov 2019 14:04:40 -0500
Received: from new-01-2.privateemail.com ([198.54.127.55]:1257 "EHLO
        NEW-01-2.privateemail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbfKTTEk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 14:04:40 -0500
Received: from MTA-08-1.privateemail.com (unknown [10.20.147.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by NEW-01.privateemail.com (Postfix) with ESMTPS id F14CA60BA3;
        Wed, 20 Nov 2019 19:04:39 +0000 (UTC)
Received: from MTA-08.privateemail.com (localhost [127.0.0.1])
        by MTA-08.privateemail.com (Postfix) with ESMTP id DBE4D6003E;
        Wed, 20 Nov 2019 14:04:39 -0500 (EST)
Received: from [10.10.42.1] (unknown [10.20.151.235])
        by MTA-08.privateemail.com (Postfix) with ESMTPA id B0F5A60033;
        Wed, 20 Nov 2019 19:04:39 +0000 (UTC)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
From:   Derek Yerger <derek@djy.llc>
Mime-Version: 1.0 (1.0)
Subject: Re: PROBLEM: Regression of MMU causing guest VM application errors
Date:   Wed, 20 Nov 2019 14:04:38 -0500
Message-Id: <7F99D4CD-272D-43FD-9CEE-E45C0F7C7910@djy.llc>
References: <20191120181913.GA11521@linux.intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Bonzini, Paolo" <pbonzini@redhat.com>
In-Reply-To: <20191120181913.GA11521@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: iPhone Mail (17A878)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> Debug patch attached.  Hopefully it finds something, it took me an
> embarassing number of attempts to get correct, I kept screwing up checking
> a bit number versus checking a bit mask...
> <0001-thread_info-Add-a-debug-hook-to-detect-FPU-changes-w.patch>

Should this still be tested despite Wanpeng Li’s comments that the issue may have been fixed in a 5.3 release candidate?

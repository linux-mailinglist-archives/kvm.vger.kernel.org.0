Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8FB33876D
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 11:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfFGJy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 05:54:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:34433 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726844AbfFGJy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 05:54:27 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jun 2019 02:54:26 -0700
X-ExtLoop1: 1
Received: from rjwysock-mobl1.ger.corp.intel.com (HELO [10.249.139.208]) ([10.249.139.208])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2019 02:54:24 -0700
Subject: Re: [patch 1/3] drivers/cpuidle: add cpuidle-haltpoll driver
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     kvm-devel <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LDhMKNbcODwqHDhcKZ?= <rkrcmar@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Wanpeng Li <kernellwp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Raslan KarimAllah <karahmed@amazon.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux PM <linux-pm@vger.kernel.org>
References: <20190603225242.289109849@amt.cnet>
 <20190603225254.212931277@amt.cnet>
From:   "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Organization: Intel Technology Poland Sp. z o. o., KRS 101882, ul. Slowackiego
 173, 80-298 Gdansk
Message-ID: <15323308-131f-6ae0-16d8-225aa275e89c@intel.com>
Date:   Fri, 7 Jun 2019 11:54:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190603225254.212931277@amt.cnet>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/4/2019 12:52 AM, Marcelo Tosatti wrote:

It is rather inconvenient to comment patches posted as attachments.

Anyway, IMO adding trace events at this point is premature, please move 
adding them to a separate patch at the end of the series.



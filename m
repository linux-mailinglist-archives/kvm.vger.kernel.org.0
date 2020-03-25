Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672A7192879
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 13:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCYMct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 08:32:49 -0400
Received: from 8bytes.org ([81.169.241.247]:55596 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCYMct (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 08:32:49 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 00C7C2CC; Wed, 25 Mar 2020 13:32:47 +0100 (CET)
Date:   Wed, 25 Mar 2020 13:32:46 +0100
From:   Joerg Roedel <joro@8bytes.org>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: Re: [PATCH 2/4] KVM: SVM: Move Nested SVM Implementation to nested.c
Message-ID: <20200325123246.GA11538@8bytes.org>
References: <20200324094154.32352-1-joro@8bytes.org>
 <20200324094154.32352-3-joro@8bytes.org>
 <87d0917ezq.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0917ezq.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly,

your renaming suggestions make sense, I will send follow-on patches to
do that.

Regards,

	Joerg


Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD533B3C09
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 07:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbhFYFSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 01:18:44 -0400
Received: from h4.fbrelay.privateemail.com ([131.153.2.45]:59018 "EHLO
        h4.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230139AbhFYFSn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Jun 2021 01:18:43 -0400
Received: from MTA-11-4.privateemail.com (mta-11.privateemail.com [198.54.118.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h3.fbrelay.privateemail.com (Postfix) with ESMTPS id B25EA80C65
        for <kvm@vger.kernel.org>; Fri, 25 Jun 2021 01:16:22 -0400 (EDT)
Received: from mta-11.privateemail.com (localhost [127.0.0.1])
        by mta-11.privateemail.com (Postfix) with ESMTP id 60C3680094;
        Fri, 25 Jun 2021 01:16:21 -0400 (EDT)
Received: from [192.168.0.46] (unknown [10.20.151.241])
        by mta-11.privateemail.com (Postfix) with ESMTPA id B114C8008B;
        Fri, 25 Jun 2021 01:16:20 -0400 (EDT)
Date:   Fri, 25 Jun 2021 01:16:14 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Re: Question regarding the TODO in virt/kvm/kvm_main.c:226
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <2ZR8VQ.IJMS3PQLNFAS3@effective-light.com>
In-Reply-To: <HCVNTQ.0UPDP6HCEHBP3@effective-light.com>
References: <HCVNTQ.0UPDP6HCEHBP3@effective-light.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping

On Tue, May 25 2021 at 07:45:53 AM -0400, Hamza Mahfooz 
<someguy@effective-light.com> wrote:
> Would it be preferable to remove kvm_arch_vcpu_should_kick or
> kvm_request_needs_ipi when merging them. I ask since, the last time I
> checked, both functions are only used in kvm_main.c on Linus's tree.
> 



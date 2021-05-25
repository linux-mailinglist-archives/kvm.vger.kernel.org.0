Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF92390068
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 13:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbhEYL6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 07:58:01 -0400
Received: from h2.fbrelay.privateemail.com ([131.153.2.43]:55920 "EHLO
        h2.fbrelay.privateemail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231866AbhEYL6B (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 07:58:01 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 May 2021 07:58:00 EDT
Received: from MTA-10-1.privateemail.com (mta-10.privateemail.com [68.65.122.20])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by h1.fbrelay.privateemail.com (Postfix) with ESMTPS id E3B2980646
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 07:46:02 -0400 (EDT)
Received: from MTA-10.privateemail.com (localhost [127.0.0.1])
        by MTA-10.privateemail.com (Postfix) with ESMTP id 93B506011B;
        Tue, 25 May 2021 07:46:00 -0400 (EDT)
Received: from [192.168.0.46] (unknown [10.20.151.222])
        by MTA-10.privateemail.com (Postfix) with ESMTPA id D12066011A;
        Tue, 25 May 2021 07:45:59 -0400 (EDT)
Date:   Tue, 25 May 2021 07:45:53 -0400
From:   Hamza Mahfooz <someguy@effective-light.com>
Subject: Question regarding the TODO in virt/kvm/kvm_main.c:226
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <HCVNTQ.0UPDP6HCEHBP3@effective-light.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Would it be preferable to remove kvm_arch_vcpu_should_kick or
kvm_request_needs_ipi when merging them. I ask since, the last time I
checked, both functions are only used in kvm_main.c on Linus's tree.



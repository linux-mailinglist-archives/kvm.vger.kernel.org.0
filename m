Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210EB492B05
	for <lists+kvm@lfdr.de>; Tue, 18 Jan 2022 17:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347215AbiARQTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jan 2022 11:19:03 -0500
Received: from foss.arm.com ([217.140.110.172]:60646 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236454AbiARQSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jan 2022 11:18:34 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 90C001FB;
        Tue, 18 Jan 2022 08:18:33 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EFC523F774;
        Tue, 18 Jan 2022 08:18:31 -0800 (PST)
Date:   Tue, 18 Jan 2022 16:18:40 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, lvivier@redhat.com,
        imbrenda@linux.ibm.com, david@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [kvm-unit-tests] Permitted license for new library
Message-ID: <YeboYFQQtuQH1+Rf@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

I would like to know what licenses are permitted when adding a new library
to kvm-unit-tests (similar to libfdt). Is it enough if the library is
licensed under one of the GPLv2 compatible licenses [1] or are certain
licenses from that list not accepted for kvm-unit-tests?

[1] https://www.gnu.org/licenses/license-list.html#GPLCompatibleLicenses

Thanks,
Alex

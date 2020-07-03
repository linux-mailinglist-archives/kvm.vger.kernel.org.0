Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A198E2140D0
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 23:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726753AbgGCV3P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 17:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGCV3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jul 2020 17:29:14 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8AFC061794;
        Fri,  3 Jul 2020 14:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=/7u1y2wkt8wxlyjfpGZrdn4AtvrSo84WKKJqoNgDn0k=; b=nUmxfeQV5k3Ubscn93XikvnOBc
        KLizXX2WRDer+wtVaxKXvUcXH7SWHQpWXK+M/L2aCbUpw/BeqWW6gd6XhXmKqJgJJX8hh1/75ls3J
        oGmrkgZJC/kSI1zxbY+IicVDxqAkANF7VXjGecUXKt6vs2Al3gZdcpluGHK7ZwCnLZ0fQpXm8jXbd
        lo2gFJHbFmrZ1nyt4QEmG4yRqFwf3gSFEhQbyBc8QxESVzCwUN5FFk3cP1ErtNBgtLvFRZvw1FuM/
        zko/+epNLWqqwM95pqzgbWQEEGBme1HwfXJ6nWhC9vqQu1DpyQRhjThI+3phyTBCuKZ0xdZXo2N0K
        rxjXjYtg==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jrTF9-0006KB-M3; Fri, 03 Jul 2020 21:29:12 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 0/2] Documentation: virt: eliminate duplicated words
Date:   Fri,  3 Jul 2020 14:29:04 -0700
Message-Id: <20200703212906.30655-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop doubled words in Documentation/virt/kvm/.


Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org


 Documentation/virt/kvm/api.rst     |   16 ++++++++--------
 Documentation/virt/kvm/s390-pv.rst |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7E1639A68
	for <lists+kvm@lfdr.de>; Sun, 27 Nov 2022 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiK0MWa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 27 Nov 2022 07:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiK0MW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 27 Nov 2022 07:22:28 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C219010071
        for <kvm@vger.kernel.org>; Sun, 27 Nov 2022 04:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=vL5cIL2DL1OGtdKBIAVdIL/AKnDP1bjRqFRb1Y9gMwc=; b=H+JdHq+9RwQ7HaGNQzSy4JyPqQ
        VuOc0wQTW/iQvc/aCT9Uz39amMiyujZdznCk/uJkj/TRDq3PWXQorbSPqRyM6bGiDUc/drme2T5Ah
        0cda0vyESFNCtZWP7OjjJk748pGgkT/bsjXzlYyIO0hYOVG/KKvReiW/3rdiLculjiO66m6Gv1sLd
        HYzrj+Ig68RAGXElC8uCeERLSECiVEZMWsplkXDbQTy6d0V1pb453k5Scxi83IWmtIcbGh1LyxZW7
        pws9X4PXdoGjWLyJcDfXf5uDCK4yuqaZyycEZ9rlGmAFb4u+0eMIf8Ya8EI+yKovd8+4MM7v+MnSg
        FvtMrOOw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGft-00BZsa-7s; Sun, 27 Nov 2022 12:22:21 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ozGfl-0012dK-Tm; Sun, 27 Nov 2022 12:22:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Paul Durrant <paul@xen.org>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: [PATCH v1 0/2] KVM: x86/xen: Runstate cleanups on top of kvm/queue
Date:   Sun, 27 Nov 2022 12:22:08 +0000
Message-Id: <20221127122210.248427-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Clean the update code up a little bit by unifying the fast and slow 
paths as discussed, and make the update flag conditional to avoid 
confusing older guests that don't ask for it.

On top of kvm/queue as of today at commit da5f28e10aa7d.

(This is identical to what I sent a couple of minutes ago, except that 
this time I didn't forget to Cc the list)



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6F85A16F6
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 18:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiHYQnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 12:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241906AbiHYQm0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 12:42:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A454BB019
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 09:42:23 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 44AE05C16B;
        Thu, 25 Aug 2022 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661445742; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwALivMSNTL2ziKxOX86+ovOjV4tDTBYAn92D1Fsmhc=;
        b=U6jw540QQxeXR8jM5yentDmGbwOHtg6qfquwHIoxq3E7uMIxBvFKH6M9DMW/N2fCD/gtk3
        1TQ2LyZcIWpt6dnRpYYdZ4NB6H6mugNX/vA35BCO17VqGjOWqj9SbL2I9RB0/URB3swX9r
        zUhZ6FIxLAmUlhrkSvmjib7T434Qxfg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661445742;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FwALivMSNTL2ziKxOX86+ovOjV4tDTBYAn92D1Fsmhc=;
        b=YtmNQo6C4Jna4Rkk7/0OJGMXUt1t+SjCBuGupFrXArcleUcTAEPDTIpYUv9AqpzMxHdCNk
        WpY4xelvMSuUbGCw==
Received: from vasant-suse.suse.de (unknown [10.163.24.178])
        by relay2.suse.de (Postfix) with ESMTP id E218C2C141;
        Thu, 25 Aug 2022 16:42:21 +0000 (UTC)
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     seanjc@google.com
Cc:     Thomas.Lendacky@amd.com, bp@suse.de, erdemaktas@google.com,
        jroedel@suse.de, kvm@vger.kernel.org, marcorr@google.com,
        pbonzini@redhat.com, rientjes@google.com, zxwang42@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder from Linux
Date:   Thu, 25 Aug 2022 18:42:21 +0200
Message-Id: <20220825164221.17971-1-vkarasulli@suse.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <Ylm0ZmhaklG9AqND@google.com>
References: <Ylm0ZmhaklG9AqND@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

     There is at least one test that I know uses string IO i.e. x86/amd_sev.c.
     I will check if there are more.

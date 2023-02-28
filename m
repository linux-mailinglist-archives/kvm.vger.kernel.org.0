Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933126A579B
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 12:17:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbjB1LR5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 06:17:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjB1LRz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 06:17:55 -0500
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02CB1A9
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 03:17:53 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id B4BB8320093E
        for <kvm@vger.kernel.org>; Tue, 28 Feb 2023 06:17:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 28 Feb 2023 06:17:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.fm; h=
        cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1677583071; x=1677669471; bh=yvjlCI3txL
        LE93Sd968GXY7YaAiAUE+clhRUl9XNwsE=; b=QMbniT5OkjYNcP13SWsIlGh/En
        OAwh5Tvv6Ouq0xVRB95x5n8nFA1orYkeSMrlTefEMxTz5Y8BgqJgBp1ODuXgV8rk
        0RZnf/0SidWX/JTjsxCwqtwBFiehRSUSZAImE8Xnhnog+w4rUgL08Q4IUghbDx3b
        mWWqtoOYG3jieiTi2PdgWH5ZCj1vBpTFnxd/eUAiSrOYXABEusT+IdMc7GmqMPcT
        Zw4n/9QJHm3BTLFIhi8+v9VGRskFqkEMZJJDz6I2HYlSkibF1nNpnxsH7vztYRuG
        GH9W6+LJiRd4/BfFwieSM7hcbhB+AddxrDun6oLD5X0R53U4B/j4QqPAyHCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:feedback-id:feedback-id:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1677583071; x=1677669471; bh=yvjlCI3txLLE93Sd968GXY7YaAiA
        UE+clhRUl9XNwsE=; b=Yx3nmqWoR5BTcD8u0cvvX8ywrVwYAo1uo3JoG39K34yr
        n3JYQPs8+dXeO2sKECNw8zkUCdaFKGBoW4Dt3og+Ksi7GKQW2vgbeWf9OOR5qQ9n
        IdIBPq0FIdNASjWBOSHJPpJRBi8K9S3eCrHQ7S96eR1d2JRwtncZV6Agj5hl6UXr
        csL9/pgZBrabZwU00za4a9Mu9XAvSesksMNdlmyHHaeZlG4l10EYtz90goW1ia+u
        4CMXeMNTlHBQ3Etdf4aefH/+GC56zLfcnlsQtP88L7nzdGiQ0vNnHblDbl/QKCgb
        TuGYn8edTfvHZekAA06xSfYLM+AZ4oy9KVCK1PXkeg==
X-ME-Sender: <xms:3-L9Y7Y-PZGoPBi5ZgEapl6KhnGD-70kwL6sxLUJsLLaKmekdH6SLQ>
    <xme:3-L9Y6ZTKcklbM82F3iLmBA1To2S4PPkWJ3ajxBzRMUraR_YtHarDv2XxwClZPnQs
    mfz1ndDU3TCmQ>
X-ME-Received: <xmr:3-L9Y98ZKNCgW5uk54nyOHTxCDQYcXGjatffEo1a8czI41j1_kKb6lej0byPmW5hgeaQO2NAeCPyQC4ZmmiKW5WXuWUSN12Ytrz5x_j6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelvddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkgggtgffothesthhqgh
    dtvddtjeenucfhrhhomhepoegsihhllhiisehfrghsthhmrghilhdrfhhmqeenucggtffr
    rghtthgvrhhnpeekgedvtdfhleeltedtkeefgfehiedtfedvudekkefgtdelveeuieffvd
    evvdfhgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsihhllhiisehfrghsthhmrghilhdrfhhm
X-ME-Proxy: <xmx:3-L9YxrKyCjBw5gLu3-ozo1J88BFZjGFh76RbfkLj9EwgcRn2nkUhQ>
    <xmx:3-L9Y2otTdtDVn5--G3qBJiemeWhZuf1xT3yAg9KVDiWmmua4syoQg>
    <xmx:3-L9Y3QuSAFNGnYP4oI3DqQPSPOMOczMPECIkt6dWE99rPv1M-n5Qg>
    <xmx:3-L9Y0EVCjoldssGANStoLEqTcz8CPj5UIVl8MsrRASqpVgKiY-dAQ>
Feedback-ID: i8cf946af:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <kvm@vger.kernel.org>; Tue, 28 Feb 2023 06:17:50 -0500 (EST)
From:   <billz@fastmail.fm>
To:     <kvm@vger.kernel.org>
Subject: QUESTION: INT1 instruction for breakpoints
Date:   Tue, 28 Feb 2023 11:17:47 -0000
Message-ID: <000b01d94b66$4be1d8e0$e3a58aa0$@fastmail.fm>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdlLZWvw4Sfv0RpNQUyNFGreZ3AwPw==
Content-Language: en-us
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is it possible to use the INT1 (instead of INT3) instruction for =
breakpoints under KVM? It does not seem that this instruction causes a =
KVM_EXIT_DEBUG (or any other exit) and it is silently skipped instead.

If it is possible, how should I configure the KVM API to receive such =
exits?

Bill



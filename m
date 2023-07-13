Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124E8752801
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjGMQG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 12:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjGMQGz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 12:06:55 -0400
X-Greylist: delayed 598 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Jul 2023 09:06:50 PDT
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0CA71BEB;
        Thu, 13 Jul 2023 09:06:50 -0700 (PDT)
Received: from 8bytes.org (pd9fe94eb.dip0.t-ipconnect.de [217.254.148.235])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id B01B828012A;
        Thu, 13 Jul 2023 17:50:24 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1689263424;
        bh=OLJU3SR6cRiJ6OsOAtXZ0G0weObZUi+vKis4ETdMDq8=;
        h=Date:From:To:Cc:Subject:From;
        b=B4SXyn6rxFd9d9kM1MadPeDKBKhPsBYAaoYXWfrO24UOMnxYJZSd/JdEWiVrU9STk
         TQWp1IETI7NzkBQUbpqMHlVfoLmfcvfm9HQuBoWWER/Or3nOyDgjZPsDDtQVuBGgFl
         vlcNpvTH8qWvk6rQUTSeb42TMNSFpH2w5Uo84C21EMvqYgZJFZ2RU9wAXZ3oJsEKnr
         OxW6kfRZ5/jzZ9q950rQO7Cmr1e95nwjWl9NzxJc490KUryPqLUDT7sNZZ2Pxdo+dk
         RcWLY9RE6euw49DkQc7eRezkLnh5Mvgc0yyCTDgemVYtQwZ/JOfvLxpoXOygfBdrTm
         z2a7cX+z2BGEg==
Date:   Thu, 13 Jul 2023 17:50:23 +0200
From:   =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To:     linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-sgx@vger.kernel.org
Cc:     Dhaval Giani <dhaval.giani@gmail.com>
Subject: [CfP] Confidential Computing Microconference @ LPC 2023
Message-ID: <ZLAdPyqn8glGgYjT@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

We are pleased to announce the call for presentations for this years
Confidential Computing MC at the Linux Plumbers Conference.

In this microconference we want to discuss ongoing developments around
Linux support for memory encryption and support for confidential
computing in general.

Topics of interest include:

	* Support for unaccepted memory

	* Attestation workflows

	* Confidential Computing threat model

	* Secure VM Service module (SVSM) and paravisor architecture and implementation

	* Live migration of confidential virtual machines

	* ARM64 Confidential Computing

	* RISC-V CoVE

	* Secure IO and device attestation

	* Intel TDX Connect

	* AMD SEV-TIO

Please use the LPC CfP process to submit your proposals. Submissions can
be made via

	https://lpc.events/event/17/abstracts/

Make sure to select "Confidential Computing MC" as the track and submit
your session proposal by August 25th. Submissions made after that date
can not be included into the microconference.

Looking forward to seeing all of you in Richmond, Virginia in November!

Thanks,

	Joerg


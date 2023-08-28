Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBAD78B289
	for <lists+kvm@lfdr.de>; Mon, 28 Aug 2023 16:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbjH1OEU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Aug 2023 10:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbjH1ODu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Aug 2023 10:03:50 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5799712F
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 07:03:46 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-68a3e943762so2795450b3a.1
        for <kvm@vger.kernel.org>; Mon, 28 Aug 2023 07:03:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693231426; x=1693836226;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IFFX7eMPzkrYgLogvMeXxd4wRFHGqYgPSd5LHSEAd0=;
        b=iM1QUBgEdF7JqZXIYL1YyVPhlOav6U9kE+BjC3wj76nNvOBD+aB/UJ2FNkuOLRPJ+Y
         jPQE94cy7Szo1OvmpH1Rurkv82yHCyrNTnMOcbk2SfvvqmhiQjRTdLhmPkl5Ya/AWegV
         IgztBooW6E1n5F1zi/YyczLZdZSkEB5lE3jz4DWAAuwN/82dBPWlXCTmpYJyBaqEAw8j
         ad53R1XdQgv/eGXT1CtkQhtT2WJD/spyrklANIIN9yntTo2wxIpn4jay2/OMV0cA0Sgd
         RtSodtAm51E/qmYFxNK/v7xOAp0qv9aY5dCxyY779iOwT9RBs8iVWM38tDzpJsEFbfJP
         wD8w==
X-Gm-Message-State: AOJu0YyRfCZQLhHev4A5WhdbvC1gUW8khjUG7c3ucc6CtDQXl6HNTrYI
        /YI182NFNd5NNIYYOS5kd8k=
X-Google-Smtp-Source: AGHT+IFG0bmHs4i7t9hz71KPcBeXu4hA8Vhr56gE7lAMEg9SMsPZI/6SmPqC4OCIa+Bdv9HQWhKk7g==
X-Received: by 2002:a05:6a21:7890:b0:14c:d494:77d0 with SMTP id bf16-20020a056a21789000b0014cd49477d0mr9398763pzc.26.1693231425284;
        Mon, 28 Aug 2023 07:03:45 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with ESMTPSA id j7-20020a62e907000000b0064d57ecaa1dsm6648444pfh.28.2023.08.28.07.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 07:03:26 -0700 (PDT)
Date:   Mon, 28 Aug 2023 23:03:06 +0900
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Linux IOMMU <iommu@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?utf-8?B?SsO2cmc=?= Roedel <jroedel@suse.de>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: The VFIO/IOMMU/PCI MC at LPC 2023
Message-ID: <20230828140306.GA1457444@rocinante>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello everyone!

The Linux Plumbers Conference will start in about two months, so please
remember to book your attendance.

Also, keep an eye on the official conference website for updates:

  https://lpc.events

That said, on behalf of the PCI sub-system maintainers, I would like to
invite everyone to join our annual VFIO/IOMMU/PCI micro-conference (MC).

We are hoping to bring together, both in person and online, everyone
interested in the VFIO, IOMMU, and PCI space to talk about the latest
developments and challenges in these areas.

You can find the complete MC proposal at:

  https://drive.google.com/file/d/1U3_WvPzVeP7DcTSs5FN7jZ2EtTTzUSor

If you are interested in participating in our MC and have topics to propose
and would like to submit a talk for the MC, please follow the Call for
Papers (CfP) process at https://lpc.events/event/17/abstracts, selecting
the "VFIO/IOMMU/PCI MC" from the available tracks.  There is still time to
submit a proposal.

Join us!  We look forward to your presence and active participation at the
event.

Please get in touch with me directly if you need any assistance or have any
questions.

See you at the LPC 2023!

	Alex, Bjorn, Jörg, Lorenzo and Krzysztof

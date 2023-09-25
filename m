Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62AFA7AD363
	for <lists+kvm@lfdr.de>; Mon, 25 Sep 2023 10:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjIYIcO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Sep 2023 04:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbjIYIcN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Sep 2023 04:32:13 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E07BF;
        Mon, 25 Sep 2023 01:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=SAhJ+jdVU49TjbtNyNnKVLRq9FdNzxDdxcTj74eMwXo=; b=RVyJrjkdCS9Zy5FDj6d5dsHXrs
        mgSSy78/faykG8nah3BQL4pvQ6TgUlLg2DMkXh2Pg+dZmhWpzbTUmACpt3CQ3Aimf4rbQSbJYfuwp
        Dvpmq3wkrW1NHmc3c4huMa3gYZVjagMlXaB1DceMqzFyjjqTdKXRZAbmY9dmk2l9s8Gga1tjlazMq
        T95CjhWC8yrksj3xAAlc+DX3G1pMUGUCgEK73rPsOLjzVxlMEUI3syHVyly+wW88/3t7w63guRePW
        KxyZBHUR2jOB5fpxFBPCMqSMbno1zusoTBPqNcQz3O+Bgf0U+ia2fyODZZ7TR1IVoIqjY0gea+hcD
        GBlfbx0A==;
Received: from [31.94.67.251] (helo=[127.0.0.1])
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qkh0b-000QWY-3P; Mon, 25 Sep 2023 08:32:03 +0000
Date:   Mon, 25 Sep 2023 10:31:57 +0200
From:   David Woodhouse <dwmw2@infradead.org>
To:     Like Xu <like.xu.linux@gmail.com>,
        Sean Christopherson <seanjc@google.com>
CC:     Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v6=5D_KVM=3A_x86/tsc=3A_Don=27t_sync?= =?US-ASCII?Q?_user-written_TSC_against_startup_values?=
User-Agent: K-9 Mail for Android
In-Reply-To: <b6661934-53d1-f7ca-d3d6-31b32a2ebb05@gmail.com>
References: <20230913103729.51194-1-likexu@tencent.com> <5367c45df8e4730564ed7a55ed441a6a2d6ab0f9.camel@infradead.org> <2eaf612b-1ce3-0dfe-5d2e-2cf29bba7641@gmail.com> <ZQHLcs3VGyLUb6wW@google.com> <3912b026-7cd2-9981-27eb-e8e37be9bbad@gmail.com> <7c2e14e8d5759a59c2d69b057f21d3dca60394cc.camel@infradead.org> <fbcbbf94-2050-5243-664a-b65b9529070c@gmail.com> <b6661934-53d1-f7ca-d3d6-31b32a2ebb05@gmail.com>
Message-ID: <4ACB424D-F9F4-4233-89A4-61CC5B4E5A77@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25 September 2023 09:36:47 CEST, Like Xu <like=2Exu=2Elinux@gmail=2Ecom=
> wrote:
>Ping for further comments and confirmation from Sean=2E
>Could we trigger a new version for this issue ? Thanks=2E

I believe you just have a few tweaks to the comments; I'd resend that as v=
7=2E

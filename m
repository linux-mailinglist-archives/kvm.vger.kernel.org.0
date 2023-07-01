Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40917744A72
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 18:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjGAQJ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Jul 2023 12:09:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjGAQJ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Jul 2023 12:09:27 -0400
Received: from out-59.mta0.migadu.com (out-59.mta0.migadu.com [IPv6:2001:41d0:1004:224b::3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80DE5270E
        for <kvm@vger.kernel.org>; Sat,  1 Jul 2023 09:09:25 -0700 (PDT)
Date:   Sat, 1 Jul 2023 18:09:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1688227763;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2K3lDhjz4u+lF/Bljw4ZfjeN0bZPximroHpBDjscEY=;
        b=kGS1TvLsFCvo4enQM5gX8F+rR6uknCrG5GTm9V0aHt3BeMk3khD58piZlhBmxYjRsfWOiy
        ART/jMefZsIRWrT3Y+3Q6HEIGeWo7GjWULP7wa6c4HkYCieC38w3HBui9G2Ws3f7annmVW
        +ld6iqKI0Pgswqi393Sf37wWD/UNRa0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     =?utf-8?B?5Lu75pWP5pWPKOiBlOmAmumbhuWbouiBlOmAmuaVsOWtl+enkeaKgOaciQ==?=
         =?utf-8?B?6ZmQ5YWs5Y+45pys6YOoKQ==?= <renmm6@chinaunicom.cn>
Cc:     kvm <kvm@vger.kernel.org>, pbonzini <pbonzini@redhat.com>,
        rmm1985 <rmm1985@163.com>
Subject: Re: [kvm-unit-tests PATCH v3] run_tests: add list tests name option
 on command line
Message-ID: <20230701-992ccd2587600901c81700dd@orel>
References: <20230512090928.3437244-1-renmm6@chinaunicom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230512090928.3437244-1-renmm6@chinaunicom.cn>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 12, 2023 at 05:09:28PM +0800, 任敏敏(联通集团联通数字科技有限公司本部) wrote:
> From: rminmin <renmm6@chinaunicom.cn>
> 
> Add '-l | --list' option on command line to output
> all tests name only, and could be filtered by group
> with '-g | --group' option.
> 
> E.g.
>   List all vmx group tests name:
>   $ ./run_tests.sh -g vmx -l
> 
>   List all tests name:
>   $ ./run_tests.sh -l
> 
> Signed-off-by: rminmin <renmm6@chinaunicom.cn>
> ---
>  run_tests.sh | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
>

Merged, thanks.

drew

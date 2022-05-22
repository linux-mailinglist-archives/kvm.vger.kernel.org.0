Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F386A5302DE
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 13:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343890AbiEVL5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbiEVL5F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 07:57:05 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03E723616E;
        Sun, 22 May 2022 04:57:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id wh22so23306228ejb.7;
        Sun, 22 May 2022 04:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DQtGOV8ehr9B0byuPgB/R0qAJIaG0/ZyE72cxpjHldY=;
        b=qG3Kocdsq2oYYGDEOFNTT93XeYI9iYcUWVQ/xcuqMlQWR+ZjOVjzShfb129BRCBeZA
         IbjnscCqLlyomggb5cyR9GpqqOBdpUuUo3+FbJYLbl0iiv4HCdnE6oUZAjMcMn8rI7k4
         0hiscQzwOz5MmXbxTMw0aR1wARxwwUQ1FuY3GMHNU3MYRkf2+RKVREPc8am7/wzdyl9t
         oIyX9zl9X57zupPpZORXrjsSN9N5PSh3n0Y67eW7PS38UKVmdPQe7ua4dEOBiXOcWWqU
         BGUgHNpBaUTmrppJ4h/Xnpqc8TBObkcgTfQfATGh0SAgYKROqWnr/m2p+Lv8tSSupBQG
         Eqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DQtGOV8ehr9B0byuPgB/R0qAJIaG0/ZyE72cxpjHldY=;
        b=nMGss4TQkRd7iwP621prHlcCMgN0H1xlWliiSUCNU6tovItVFm31XeJT6l3HAmMrVL
         /FWLlipyGgKBwo5pxK6J6zrWPEbhjKwCgWXxKi2QgbYb1I6+wotgU9sIV9DLEDqnCEQV
         pRO1HwGS/8rv253wV/MuXwFI5W3TpaCaMOLXEowIDZPcnSxJok2lOqCf4J9vR+VBA00P
         9emmlRKMRU4aR/lP/n9dZooGQc1i/j+wseIAJWSBf2fkRN1r9ScuNYRX8MxiOQZ0xJTD
         BJ9qSJuFMW4Xb8AWJ1GEExpTAx7ZpMG/XTdKLSFuxxfQeKwwft3OXfUW/Nym+marSfHa
         zmeA==
X-Gm-Message-State: AOAM532klAYEXOMBO2ASQuhTeuIEBBTJXFYWhkYJf5zLpb8FOjy6Hr/2
        0mQfVMHr63g4NSDslb5ZlJg=
X-Google-Smtp-Source: ABdhPJyUp97Woq4Tojt0R/LZFMRQbE+AliJIsobK1w7h8qb86kKoEvaA54Id06XPIzhUaW1XPVm0Cw==
X-Received: by 2002:a17:907:7282:b0:6fa:9365:f922 with SMTP id dt2-20020a170907728200b006fa9365f922mr15297634ejc.262.1653220621612;
        Sun, 22 May 2022 04:57:01 -0700 (PDT)
Received: from mail (239.125-180-91.adsl-dyn.isp.belgacom.be. [91.180.125.239])
        by smtp.gmail.com with ESMTPSA id jo14-20020a170906f6ce00b006feb5cae5f0sm2338997ejb.132.2022.05.22.04.57.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 04:57:01 -0700 (PDT)
Date:   Sun, 22 May 2022 13:57:00 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Guenter Roeck <linux@roeck-us.net>,
        kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-staging@lists.linux.dev,
        "open list:TI ETHERNET SWITCH DRIVER (CPSW)" 
        <linux-omap@vger.kernel.org>, linux-nvme@lists.infradead.org,
        linux-hwmon@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-sparse@vger.kernel.org,
        linux-m68k <linux-m68k@lists.linux-m68k.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 736ee37e2e8eed7fe48d0a37ee5a709514d478b3
Message-ID: <20220522115700.vg4hsytav74sy3x6@mail>
References: <6285958d.+Z2aDZ4O1Y9eiazd%lkp@intel.com>
 <0530d502-1291-23f3-64ac-97bd38a26bd4@roeck-us.net>
 <CAMuHMdU3SYOwE5ftDwymQpVwWmpbC=1Ytyp0Y9GaeUS2i1cP+A@mail.gmail.com>
 <CAMuHMdVx7r-4TVV9uVJppT-7ZAriov01BUNk4ghU9Bs4uY28vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVx7r-4TVV9uVJppT-7ZAriov01BUNk4ghU9Bs4uY28vQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 02:46:20PM +0200, Geert Uytterhoeven wrote:
> > The "(void)" makes sure there is no return value.
> > Which matters if the result of a function returning void is propagated
> > to another function returning void.
> 
> Which, FTR, sparse also doesn't like:
> 
>     error: return expression in void function


You should get this message only if the expression is itself not void.
For example:
	$ cat test.c
	extern void fun(void);
	
	static void ko(int *ptr)
	{
		return *ptr;
	}
	
	static void ok1(int *ptr)
	{
		return (void) *ptr;
	}
	
	static void ok2(int *ptr)
	{
		return fun();
	}
	$ sparse test.c
	test.c:5:16: error: return expression in void function

IOW, sparse warn only for the ko() but not for ok1() or ok2().

If you have a case whee it s not the case, please send me the
pre-processed file and I'll be glad to investigate.

Best regards,
-- Luc

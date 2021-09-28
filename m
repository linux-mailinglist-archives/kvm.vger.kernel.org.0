Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9460641AE1A
	for <lists+kvm@lfdr.de>; Tue, 28 Sep 2021 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbhI1Luq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Sep 2021 07:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240425AbhI1Lup (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Sep 2021 07:50:45 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67DD9C061575
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 04:49:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g8so82112622edt.7
        for <kvm@vger.kernel.org>; Tue, 28 Sep 2021 04:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=P6hcjUDgNRVWoQlF2WjLd9MJ396DFb3R2r9u5EtGSlM=;
        b=QCsC+6ZN/Xnv7inSwpT8QI298D3uql83+lk4wyLa8WgyUYkdmcuKWTJ4eaFIEFIayj
         irp9M5RKOqIHLFN1brA58/SF7hTi43HUBwpMpjTCJrzBqUOr01h1DTT0l3qhdiMLA3iu
         gBp+82vqFDIRj3lgM341hJCITF090YjcDYPnYPwo8Xt/vCFkZ3TQEZzW1l7UPekF4pBe
         7Ex110lV1ACCYlx/KQ2fJDDa3c38XlGN1BiaqJlfQ8P0VuiG/Z+51t6sRgueNLj6ILEd
         HXGOmsPDM3mneUVX2wqaK9RC/FeEz0xFS6xlZ0XmH80nDVIJsUdPAULNvtm0yMnsl0Yw
         JLcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=P6hcjUDgNRVWoQlF2WjLd9MJ396DFb3R2r9u5EtGSlM=;
        b=7Qp2LwNLJGiwWjlX6dSZkY018adyhtDzwS0+XO6lQS3iHNRm6LUnXe3mXvjoHX0DZy
         rcAtljEecaIkU/e0ZN1G2Yh8LNsl86jI6PDOOTOYQhXRzWcXtbrzgc78Ks0nWwLRMH8q
         6N2DU59/5tSzbmRhyqqWF8rVyBTLCPI7cNS1EgNiI1eQoHPKmOv+8hyjH2js4NikMTjG
         b4FP920CRRXWxsy8aibn4i4xL0HE1A6JI1pElz1/rg+FO5+k1pV2nQZuUQKCoOgytd6h
         ouFxxXAO/11KhI/m7qoUkP465JI2swykLXdpa3e8eW9pFnlJU4X6o64JaayoNrR63yqp
         WolQ==
X-Gm-Message-State: AOAM530ueMVNUi4uFBEIYHtbIc5kKfxTDoEy+2cq0s7akyX4KfvFcPrV
        B7DUtaCGFebK2dC+sxIyYZPPP/DnUL9n7CfFQ5g=
X-Google-Smtp-Source: ABdhPJxpB3dpYz0ZHx3UCKeaxiQJiwtctT6TDgosd63wxnxHqetZY2KBTGbU5NSz4XUNIcqWmIsdrSNPo2LzdlJDoB0=
X-Received: by 2002:a17:906:1341:: with SMTP id x1mr6072871ejb.277.1632829741406;
 Tue, 28 Sep 2021 04:49:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:a416:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 04:49:00
 -0700 (PDT)
Reply-To: asameraa950@gmail.com
From:   Samera Ali <hasamuhammad24@gmail.com>
Date:   Tue, 28 Sep 2021 04:49:00 -0700
Message-ID: <CAEsd0fkiJxd+keE-Q-Knwxwhz0BW6g9Bs8BYhKDHWM=P6c6wmw@mail.gmail.com>
Subject: =?UTF-8?B?0JfQtNGA0LDQstC10Lkg0YHQutGK0L/QsA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

0JfQtNGA0LDQstC10Lkg0YHQutGK0L/QsA0KDQrQn9GA0LjRj9GC0L3QviDQvNC4INC1LCBBbSBN
aXNzIHNhbWVyYSDQndCw0LzQtdGA0LjRhSDQuNC80LXQudC70LAg0LLQuCDRgtGD0Log0LIg0YLR
itGA0YHQtdC90LXRgtC+INGBDQpHb29nbGUg0Lgg0LjQt9Cx0YDQsNGFINC40L3RgtC10YDQtdGB
INC00LAg0YHQtSDRgdCy0YrRgNC20LAg0YEg0LLQsNGBLiDQmNC80LDQvCDQvdC10YnQviDQvNC9
0L7Qs9C+INCy0LDQttC90L4sDQrQutC+0LXRgtC+INCx0LjRhSDQuNGB0LrQsNC7INC00LAg0L7Q
sdGB0YrQtNGPINGBINCy0LDRgSDQuCDRidC1INGB0YrQvCDQsdC70LDQs9C+0LTQsNGA0LXQvSwg
0LDQutC+INC80Lgg0L7RgtCz0L7QstC+0YDQuNGC0LUNCtGH0YDQtdC3INC80L7RjyDQuNC80LXQ
udC7INCw0LTRgNC10YEsINC30LAg0LTQsCDQstC4INGA0LDQt9C60LDQttCwINC/0L7QstC10YfQ
tSDQt9CwINC80LXQvSDRgSDQvNC+0LjRgtC1INGB0L3QuNC80LrQuCwNCtC80L7RjyDQu9C40YfQ
tdC9INC40LzQtdC50Lsg0LrQsNGC0L4g0LrQvtC70LXQs9C4ID8/IFthc2FtZXJhYTk1MEBnbWFp
bC5jb21dDQoNCtCe0YIsIHNhbWVyYSBhbGkNCg==

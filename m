Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C866553AB41
	for <lists+kvm@lfdr.de>; Wed,  1 Jun 2022 18:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356228AbiFAQqd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jun 2022 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350860AbiFAQqc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jun 2022 12:46:32 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E1B9E9C5
        for <kvm@vger.kernel.org>; Wed,  1 Jun 2022 09:46:31 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id n28so2980751edb.9
        for <kvm@vger.kernel.org>; Wed, 01 Jun 2022 09:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=eqRg70934LOhEuzCeWKXpYN3LktkIf1z9etsTpdQxp4=;
        b=gdDSYTz4HLleYXYYZhkXmXYvgvXXeTGsPrJjEFnLWucWUiTfXajPohGOkMQ8FEFeg/
         yWVfLgN6/KcphgSOPSidE5a0ZboFhUfYozwk1bjVePpNEMz8DK336WBGmlxNQ+oAZj41
         KnbdO2zK011Ar4dAO75RYjCkQCdAP71LuCJJFBCCdrx1K5w0Ighok4QXEvrYsB2RPVZp
         cQ+ieRG6A0zxTYvdN4WXcaBv8mtXUlRpIhHvAeujMOZiIcMM7xLdwrV6zumnrOoXNSq5
         /9V5vQXCr4kLtazdebsxY4V9wmAeUvUTSbZ3AGdl1I4n6ZuBWM30caYXr196m1szOkZv
         xgXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=eqRg70934LOhEuzCeWKXpYN3LktkIf1z9etsTpdQxp4=;
        b=t5TwpJBCZzvVuwBJIpfThL56UE+V/tbG66bqfiCmr1rZtG5JkDWI55v/SVMjh19TF6
         Pr2kUnEw71e+0+ItYpuiC+G4bRGBOvNz1+Kj1bz3yeYIlwQL7I+I9f9skWxlYVnDHTdn
         KatW5t7vWtXN+hTGa/QdcC63P1gr8aSpOiRVlFhM2+pRiIWRwij/pDR+yQpnFWid6BSa
         9k0ZGRmt4DdgbQ3JWbRdpvA/NYRuC+/SpZhFkhcZFaTLptRmlxuz5Df6IcrszsauBYmB
         y8g0j8PArsDGDrUThf8TcmKiNAJV64UOk8ieSSp+zWe0229VO4CxIQB5C1I3GJlnrLKH
         iNqw==
X-Gm-Message-State: AOAM5329Rq99nb7MIJeFTnsKce7vR5yX6Otxu/uNfywI7W0OuVteF8je
        7j4Kp+41IjMPv1dRowxre5gyFan6yxClG3jbmU0=
X-Google-Smtp-Source: ABdhPJzFOzvRrqDk1G7AYVWTpuB4XZQeeWFFXGAu+aMAbSKm9Ri9yhD0L2SG1JxLJRA9/eLlZRREtyIzM06GHAWPVJI=
X-Received: by 2002:a05:6402:2925:b0:42d:d019:1716 with SMTP id
 ee37-20020a056402292500b0042dd0191716mr708829edb.110.1654101990465; Wed, 01
 Jun 2022 09:46:30 -0700 (PDT)
MIME-Version: 1.0
Sender: amoudiatchakoura@gmail.com
Received: by 2002:ab4:a609:0:0:0:0:0 with HTTP; Wed, 1 Jun 2022 09:46:29 -0700 (PDT)
From:   "Capt.Sherri" <sherrigallagher409@gmail.com>
Date:   Wed, 1 Jun 2022 16:46:29 +0000
X-Google-Sender-Auth: eE-15i9zFmistn7OK9iTruK4w-k
Message-ID: <CAGZPmGH6UG0rPtbC2=71DcrtCDzOj1PiVvUoVQfD+xrGv02iqA@mail.gmail.com>
Subject: Re: Hello Dear
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

5L2g5aW977yMDQoNCuS9oOaUtuWIsOaIkeS5i+WJjeeahOa2iOaBr+S6huWQl++8nyDmiJHkuYvl
iY3ogZTns7vov4fkvaDvvIzkvYbmtojmga/lpLHotKXkuobvvIzmiYDku6XmiJHlhrPlrprlho3l
hpnkuIDmrKHjgIIg6K+356Gu6K6k5oKo5piv5ZCm5pS25Yiw5q2k5L+h5oGv77yM5Lul5L6/5oiR
57un57ut77yMDQoNCuetieW+heS9oOeahOetlOWkjeOAgg0KDQrpl67lgJnvvIwNCumbquiOieS4
iuWwiQ0K

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59B0140FC24
	for <lists+kvm@lfdr.de>; Fri, 17 Sep 2021 17:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbhIQPX5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Sep 2021 11:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241138AbhIQPXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Sep 2021 11:23:52 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAB4C061141
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:18:34 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id v20-20020a4a2554000000b0028f8cc17378so3319296ooe.0
        for <kvm@vger.kernel.org>; Fri, 17 Sep 2021 08:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=AkgHrkJkwlHdRKYw/Z6067f0AUV6M66QSRbPsLgv5ftbYCshq4tUAWcIWt5utaicb9
         Oz02AznjoeEbRnBvCPOr5dYwFFg1fdVmkC+/vZgIbSrdmHJ8kk3lh9eRm2QTpmRI5s8n
         0J2FPhDvXV87AzhlotPu+RqQd0cDBY0sF81NcK/4R5UdkKuYcQ5PiX3V2vEa8BReTMjd
         tFOrffJU6OVpqRUVL0cAlI+F60vJMxpxwBVoypdFBGr7pQWl87vp4pM6N80njOkpglIV
         mSSiTZs+yhq3SEDgT+4+bNEcb4PexUcXAw1shHNoEdbRh8r+XPszW9a42FVdW1trYM6V
         66Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=bIkL3j1SUti+mxRknWXsGzjEHfZ++LfAOrCAj6OvBfk=;
        b=RqEiNWKVcIpzqCzpGIV/N7RIqjPNaIfm6WCOS6CytynavcYggD7VPzPG7GCAQfFwjE
         IAX3ynbe0RpuscCi0ZN1cHtN8MI99oP8nu4+b14PJl/lTkudUeLDESArH5tlWN0UCRlC
         kPLlgdQgcrEa0ESUWTY3k4PxfpVa7S3dqODySIQhauaxiJ2mGSrdVCzxh7MGUJ/wf8Gw
         2p7JYa6sbt9BMKOc2yLlb0w03ZRVIAb72b5YqHoh+T4sPDcUjzbVvbmKH3TS0fTaKCu0
         +nCBNqxq1tgQ/DYO4/MP0HwOYDMvCHoQ6HGDkxzagS90DiIn/2s3tJqp/GFUn3aB+ze1
         dyxw==
X-Gm-Message-State: AOAM531ZXMqrYI0CgC75K9ynbW7TzYwp76WP+okXgiq8hGsoQTKdtGcU
        pxGhkKpzCNDpZgEDXxmVZUMOX8f/v2D+PdMCyCnr1TFc5yA=
X-Google-Smtp-Source: ABdhPJxS6zDFQnD9z5tFyQ0wONhBrD6Kwf/wvyzeKfLvslog3bkvVbWUEAYSU4zjRUuKgJNBajR4tAb6On2rNikg5h8=
X-Received: by 2002:a4a:4954:: with SMTP id z81mr7000877ooa.34.1631891913582;
 Fri, 17 Sep 2021 08:18:33 -0700 (PDT)
MIME-Version: 1.0
From:   Ajay Garg <ajaygargnsit@gmail.com>
Date:   Fri, 17 Sep 2021 20:48:22 +0530
Message-ID: <CAHP4M8XcU+34B-Zj3ZW6+rWQNFnDXw2k8QgTjz1X-6VNNbg1iw@mail.gmail.com>
Subject: 
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

subscribe

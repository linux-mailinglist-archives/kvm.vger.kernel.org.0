Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DF943DF9F
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 13:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhJ1LC7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 07:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbhJ1LC6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 07:02:58 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B62C061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 04:00:32 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s24so4210664plp.0
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 04:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=SdeQLGcX9mvI/gMbFbBsioglPQKFAJY8wprEGUZOknk=;
        b=C0j/YY2hXkAvmHqas8a9oCawW+fEByTpd+0qMss3MgjstT9R/G17tIY5cixuIJWohW
         Apg1ZUjxV6p5gUEaO2ZoUiBU2hb7n11ZwiXKFR7YE8me3qyPFMYAuAos/UpmBGlChUMk
         iErHobbS5aScPSnZ9yTwutSqPPf4uy8lNGydZ8uY7VyQs2IiApEAOv9v/T/6AXdOp1zq
         JVsmqWESCgOCNlyuOW9gRyg9yW96lt0CafAspv5LiQ3QIr2PbgDT6OzBYoxuV2yGEZD1
         3Y+ydEyABpUL5VZoRZHi3+SBFQqx83knrxiXi1nK/jVOBAJ+qOQvNjbRryPIeCx67K7h
         dqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to;
        bh=SdeQLGcX9mvI/gMbFbBsioglPQKFAJY8wprEGUZOknk=;
        b=wP4ASOkaRCnswLS365LbaOcJy1TAmlBgyu/C0kAZruhNKkOWy3lBRfxFV+f12DCNE+
         /mbYtISUOTud4FNcbale7GBPAhiyWKDMcjnjEBHUJdHrRyCTdvKVBVXqKr6JrEshq8oo
         2ZzzaGx9OfNz+SQkDW8+PP/JsrBtmtb3S7QdWZEfdIsCmsKg1kUfDMrcv1sWZpw7iJ4r
         SX5m2yS/7nJLn2JDmaWbW3JE2kYYRWql4Bxf1HN9NEFE0D82uXCjJtLw49XUpWaDPQcI
         rWdw4a9mcq5Un7G0imyJlT+EMRKb2/rmeCqHG4GW4YcPvaeSq/JZummKuX1soJ9Sq4E6
         hCEA==
X-Gm-Message-State: AOAM533kiOyi9sUe131vT3zbNx8xRAmOxo+v83DALFMNfzcHLqrzvQpD
        A9hB/pt69oN1Jus5YyBatXAdCPREkTU5k/X0EH9jTEVa
X-Google-Smtp-Source: ABdhPJz2I3zczye4UpkNx/zWw/KYYV2t+quksiyfBLr4fujp1AKyaa0TxbHCh8y/bS5/7ICPPCFmzYDLzTuUGaotcWc=
X-Received: by 2002:a17:90b:3014:: with SMTP id hg20mr3653776pjb.168.1635418831662;
 Thu, 28 Oct 2021 04:00:31 -0700 (PDT)
MIME-Version: 1.0
Sender: audreymehiwa@gmail.com
Received: by 2002:a05:6a10:6d0:0:0:0:0 with HTTP; Thu, 28 Oct 2021 04:00:31
 -0700 (PDT)
In-Reply-To: <CAMN34wiVaFwjDP2_eHK6Mr=GZ_+BgU6Bp6p_06CKx+7JE9qa2A@mail.gmail.com>
References: <CAMN34wiSsO8EJOSTeoOr-ch3oK3G-AvbEPsX2-AwiC5HC1ACUg@mail.gmail.com>
 <CAMN34wiVaFwjDP2_eHK6Mr=GZ_+BgU6Bp6p_06CKx+7JE9qa2A@mail.gmail.com>
From:   "Mrs. Rose Guzman Donna" <ebubedikemplc@gmail.com>
Date:   Thu, 28 Oct 2021 11:00:31 +0000
X-Google-Sender-Auth: N2r91tmTSaL9TXp4s4-qnU7wGCU
Message-ID: <CAMN34wjNmT4ViYbmMBKEhnCTiuwN73y3e21o+1nNeHnUPnWEEw@mail.gmail.com>
Subject: Fwd: I'm Mrs. Rose Guzman Donna from America
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 I am contacting you because, I want to donate a huge amount of money
to help the  poor people ETC / covid19 victims and to open a charity
foundation on your behalf in your country is OK?. This involves a lot
of money Get back to me for more details. R Guzman from America

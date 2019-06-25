Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3D354F7B
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2019 14:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbfFYM7h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jun 2019 08:59:37 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:37629 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbfFYM7h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jun 2019 08:59:37 -0400
Received: by mail-ot1-f41.google.com with SMTP id s20so17150549otp.4
        for <kvm@vger.kernel.org>; Tue, 25 Jun 2019 05:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=Zj6mdLHsZGc3o/HmHLQy7PtZxliJ07149z+zuUHCxwXN4MsCj6gBPhzhYromdkwpD9
         9EWiiY59tFMiPMdvKhK7WnKCsm8ByuM8IrRHY+PPfFuuZ8tZ9ALFlXucnviTsBkNvHie
         5nilhdBCnQ7yVUyhOCDSG0Pm4yBSZEXtAq2UBdylI6EQEbP+iomZtsuwNHt/AlBevSKF
         pBFrXJA0CuwPqxxqH/4fGfSUS83XRyhGOVYhE0tTXvUdWYxXk6n4LuKLwgkLaOSWWjT/
         lq+v/GliidazAPJsz8/le4sDdC9LMhMdh/WA0ccFUvmJ9ZtNPwuED3ioRdPuImZ85QjJ
         4edQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=ZGJ8ELWYkMyOPh7m7hTtGWmTn/8vsAitJM9MlBZSNJWW7J5tGcj9sDe1Kbxj/u6ydL
         Gq+PsXwTv3udJ59OvOyS2QLJNeqflulagKUwxl1CqjxILc+L+4G5K1Z8Ynz5FvIuN+6U
         OMqEfdMiqZH8xjSp06mJq8+1OR+2mkM8tCp5sZpiHyqJszZrXqWH5wqD6Z5LxHfUQpdE
         menNGF8RXdUGFHdPEl4fuGFZOriU/yOchu+KlpNWITZUzqxb/QGcu7wqreJKxcWBPlQM
         R9eE6jM3TkwGqAgiRPxDBO/HZvBeTQyPpimyUEPzWgQ94UJbejBfOPaEqbVTODr9jEjZ
         l9nw==
X-Gm-Message-State: APjAAAUf5fEjuNbvq+Ijm20Iq5Jke5SvyFtsKCaGuPPP6/pQ7NZKlXS3
        8rAf/rMwsaLHTuXYwt8B6VJjZ+mSsNP2hbeVj7gSxg==
X-Google-Smtp-Source: APXvYqxoPShPzfFOFShqGop01L9diI55vqw+YUkB64KNIKYnFAKWZsrFL0S43allFZrL9rqyyIWmf9kGdtug4O0V7YI=
X-Received: by 2002:a9d:71cf:: with SMTP id z15mr21133957otj.21.1561467575836;
 Tue, 25 Jun 2019 05:59:35 -0700 (PDT)
MIME-Version: 1.0
From:   Will Deacon <will.deacon.lists@gmail.com>
Date:   Tue, 25 Jun 2019 13:59:24 +0100
Message-ID: <CAFQU0d_+LJPNn5Uym-jROXKLCeLGxQeN0bD8k-jRbaZz_QSA4Q@mail.gmail.com>
Subject: 
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

subscribe kvm

Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35E3DE07A
	for <lists+kvm@lfdr.de>; Sun, 20 Oct 2019 22:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbfJTUiA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Oct 2019 16:38:00 -0400
Received: from mail-ot1-f52.google.com ([209.85.210.52]:46850 "EHLO
        mail-ot1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfJTUiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Oct 2019 16:38:00 -0400
Received: by mail-ot1-f52.google.com with SMTP id 89so9241155oth.13
        for <kvm@vger.kernel.org>; Sun, 20 Oct 2019 13:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=t601pjcszREbDo+X4pa12O8Z4wM8iqIYuf9T1eWFEjA=;
        b=UIZobsHdwtqy9z1iAgG9BRFI0pu4FMIcLMbWRVu3vcTM3BYIYmkcqaUts1rJkwuWy5
         H4yOplPbNR/ZJVn72DMkvTa+Uhk7aUC94l25N1glWkBlGe/qlYuJko29+q0WkHqo4rxc
         LFYzNkSsBFi37myfshV7PANMsZo6aDKTKbXZyzOHKUIM7ij6WHmMJehBd3ceZholBjXX
         6xyOY2d1G1J4kS0JJeLDXnK3m/eSii8zVBDuZDPE5f1QcqYAGoTta7ZVM4uGy8ii/3sT
         ptt3hij2ytLI/yuHi1cItCdF5ElHTRzraCI3eaUWjONTCWkt8GnnlR0Nt81RLMtUAL83
         5CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=t601pjcszREbDo+X4pa12O8Z4wM8iqIYuf9T1eWFEjA=;
        b=Em3LAknqSUqIOwKxtABfLS0DgMtYi9GXJ8dn8s72uF2ndiY8YNtvpBAlfgTiBA2RPC
         i/uzjT61R/i2RWpT2nLW+8JadhdDWDVuAbAxAdsRRn+jLxIYf+gv9M5wjBSfRz3uTPSk
         Ph51Shn++WbprOmQTR5JiiXuSWt6smuysti2hVvKFcwKXcI4hX84Ba5WzOH6HcOov7jq
         mMtO7eCCIApw3xoFxSnPhj8jHhbkwtzXE6m0eXymq2W1rWH70lHuupXJ0IXW6vDR21z/
         cJ0pcxLDALvDsq6+6qeOzT4xFfrAAsWZvWN2oSU7l6v0DXF9TInn4tQxBIeQL20DFUvH
         gqLA==
X-Gm-Message-State: APjAAAXeeTczJAVWntwYHjV+gQrI1cMt5YPqi8dD8gKITXPnQjXhYmwv
        sgOQkABOkyhFRr84MldOOoEpO6jqclEmpE8lgdFMrjbL
X-Google-Smtp-Source: APXvYqxygAB4RUbBLkYcvSaADja3Ly33Z4f+QaPtUxZpfJgt5ulKLN98BOjbuCgIfJu1Z1bU5vUajSM5TZN59YgCiBk=
X-Received: by 2002:a9d:5e82:: with SMTP id f2mr16502247otl.34.1571603879834;
 Sun, 20 Oct 2019 13:37:59 -0700 (PDT)
MIME-Version: 1.0
From:   Mauricio Tavares <raubvogel@gmail.com>
Date:   Sun, 20 Oct 2019 16:37:48 -0400
Message-ID: <CAHEKYV7ko8B4G5VErntCzvXB3ZFDsQkJqn2k21yOgA6KGMZ98g@mail.gmail.com>
Subject: Moving important files and dirs to fileserver
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

So I need to stop being a lazy ass and update my kvm host from centos
6 to something newer. Since I can't just in-place update the OS like
ubuntu, I would like to use this opportunity to do some housecleaning.
One of the main things is move the important config dirs and files to
my fileserver so the boot disk in this host can be completely
expendable.

What do I need to save for kvm? For instance, I would think I want to
save /var/lib/libvirt and /var/run/libvirt/qemu; the vm guest disks
are logical volumes so I do not care about them in this question (i.e.
they are easy to deal with).

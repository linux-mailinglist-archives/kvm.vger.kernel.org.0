Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C62FF1073A2
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 14:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbfKVNuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 08:50:14 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:43450 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfKVNuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 08:50:14 -0500
Received: by mail-ot1-f45.google.com with SMTP id l14so6176310oti.10
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 05:50:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=flaYQZiXaqCwuebQmQyqw5d1E9h2vzUOmoRR8nElWPqgGlrDplc4uHHPjGEGtYX7e/
         hLkhRUQqdEy5hM458E3H18Qx55Q470LR/j5elqyr2ywjbbVGYnN3jeJNMIqUHWF2XOVL
         mtH0nmL8eDKVjEd+YASjgifzwGwS8aMDZB9NOQG1AjpLoh63VnXMh5G0vwSe5w9f8V9r
         F0F/cS6Z/SdVrZSvLSPc92OuyV5a4DWVB2vMULFE7XuDdLhT7Q7B48AZGQRxfEO3j4ba
         fdGMitjSQH0e9+uCB50LA9x8p+lVHZjulIjfXQg8M21rUKHQQkjrxohaMtWaOFZ8wkSr
         9REg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=alf63Pzxts5J+gihJoMEHOEyfgclydhU0zJKK8E74wI=;
        b=RY2DBHH64E0pkIzhhCYxAS/Ccj3HYVVpquQDjDyMX8EIG9lUgnU655GdLZyb0Fju8c
         6bLH6cLvfTOz4IXDklolX/zYof1VT57XB0bedtinykaxXNMQTOZ/1QHR+YLm8nz5pHmM
         Cs8oxVT7dIi2dTa7Lxq0I0uj1UnKFRJlLIsEDiFOcWj6kIkFcRgP3iEahSDc7K32a/QV
         +g/9iAyembYxHD8WIt2ffEgYReo2Rw+07B6/kxE1LU/wGuteviMHWZFmRqTLvGjNP6k8
         LEOCPLtILLGupV8xVSDy9AE7KgUORVBv2loKeHM4rcG3GCgQ70KZyVEqP7fhy2zu+7NZ
         PE2Q==
X-Gm-Message-State: APjAAAWFRk8wVYfEZRU5qMIHa6m8gAPxpo7sVW4IPfPs+jsCnqygi3Vj
        IpQRLMVsSzCE5sAclNU9LJJyElBQ2Lp9bl8qXpGAHJ0Vjsc=
X-Google-Smtp-Source: APXvYqzEtSij3S9fJLX5aFZ8cfE8gdB34k5PIAfw4PqVBIhu5TOJoaNiqvgiSdU+AXdJLzjyeUzMF87GJM98xxGNi4I=
X-Received: by 2002:a9d:18b:: with SMTP id e11mr10147521ote.305.1574430613661;
 Fri, 22 Nov 2019 05:50:13 -0800 (PST)
MIME-Version: 1.0
From:   yuan yao <yaoyuan0329os@gmail.com>
Date:   Fri, 22 Nov 2019 21:49:57 +0800
Message-ID: <CA+WM_RCB9fbpCFyVmXF_uR-BCvNmLde82Qh0t52BHnPGBjPcTQ@mail.gmail.com>
Subject: 
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

subscribe kvm

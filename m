Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67FB132942E
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 22:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241346AbhCAVvh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 16:51:37 -0500
Received: from mout.gmx.net ([212.227.17.21]:56533 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244758AbhCAVtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 16:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1614635257;
        bh=zVBUFtB0XtjblJmNjnmM9zPfSHxzFzcx47GazfY4lCs=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=K3qP7lBlbIxtPiyoA9XsWkp/BmZ0qYxL9h5wTaFTHFazh1hHJaoBazJwsrwigX42S
         6H9pcaIUJqLwF+P9V8+HS6dLvbPeHSHRY0hvVLxlhm969EXH+dwf8Sl1JB4gBQcPW3
         tkc4MKgFxacoSBDzyTzOCL3Z/1fi55A/UmFrkZIM=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from longitude ([37.201.215.134]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mq2jC-1ldVwg3Tgg-00n6Zy; Mon, 01
 Mar 2021 22:47:36 +0100
From:   =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To:     linux-doc@vger.kernel.org
Cc:     =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] docs: kvm: Fix a typo ("althought")
Date:   Mon,  1 Mar 2021 22:47:21 +0100
Message-Id: <20210301214722.2310911-1-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CTe05Txa0fPqrncPyK6o5poGV4/BtQtlMFSSGCyT/OugiTbOCbh
 3NZYAXQHyNJXS55FNFx/wjmhy1mlerNfAyoM0gXWrMpAhWKe7qJsQ8J5Buz+pT8BLcRyvat
 COANMF/m46XMhZSfasCOq+V+XBUXdc5tm4BaGFwq+84HA75nhH0DZGL0Ws0Vy7f8TMff0yn
 TB/Aw3Q9Vcjw++OGw4p0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gUfQ4K6LBMI=:g+cu8vMnkgzt7iERrau4n5
 Uzu8J1C5DNojCKpw8gMQ7Ci/ZmiE3ji9FZduOOZmNf6TUpCqVjbqjKMH7z5f3UkA2AZvFM/WM
 jgzjMpWBVG4pzPuRUgSEB3XU/ourAI5wKFz5udaOFtj3tX4dPayKlIxA1i0LUlI5zaVHLxx+v
 t3zLIipzs1X6/jjgvdeWEnz9iGSyV+JMdGPWY9/k9lTwHmAfr3Xm02A8NC8Kd5r485UtWbrSd
 DBKi0cE/HN9549g+v5rZx2kHrLU2XtzxGvvPqSSRSUrTKrFm+tuOUyOpQ5jiAYhHmHZnMZBAS
 Tyd6+2o651tJEo4ClGo69L2r3KyKMB9ys/Rl9iMTZjbBxvoYsmTE01n9XVCb/45QJCAclKV83
 B6ygez7ESh0LqZGwS5PWIJ5DN+3+VTXqH8n4GYisJqp6JWj7oIPUNq7T/vyv3SejQbNpGitMP
 2LZhP/DAoMc0yxnt5loZsLqAc+Uq5v3PhrpYHqyUKCH3mOv/GLADfavrQyK0bNZElKmkpaKKe
 GqJRJDywIA5PtKemlAdkDJFA0k70csgNosf/oIy5DumILtYLxyaycmo/T9koQ901RwYdmium/
 7numv9IgphhAw5AmseCsH7mZz4S6Ct2NKARvruckcPEnAjgMa5owtpySvE3KqCeGNjC8otxZG
 FeyPMXeFD98HgSuZxaUKGhmqmq0oX25O0izJBq22eQHmNKzpUEQj523sWtuSZHgHoiacMAVHu
 k+iwwe8cNuyZhsubYAxQ+ZPNmhiKRSdHyz9XS8Cgi9WA49KFWbHnwrzNARmMvagklzr1GPW+H
 Deo6mU8TN2oDIVLIvKqxMV2Ke5V+kvk9vYfiZfNi9jYoVKgit1lqV6GNYsQNULOdXVMZKe7lW
 f/+1Na6efeE5g0d4659A==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Jonathan Neusch=C3=A4fer <j.neuschaefer@gmx.net>
=2D--
 Documentation/virt/kvm/api.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.r=
st
index aed52b0fc16ec..3617a64e81fe2 100644
=2D-- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -55,7 +55,7 @@ not cause harm to the host, their actual behavior is not=
 guaranteed by
 the API.  See "General description" for details on the ioctl usage
 model that is supported by KVM.

-It is important to note that althought VM ioctls may only be issued from
+It is important to note that although VM ioctls may only be issued from
 the process that created the VM, a VM's lifecycle is associated with its
 file descriptor, not its creator (process).  In other words, the VM and
 its resources, *including the associated address space*, are not freed
=2D-
2.30.1


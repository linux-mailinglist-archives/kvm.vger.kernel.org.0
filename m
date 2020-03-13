Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A4D18420D
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 09:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgCMH75 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:59:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10290 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgCMH7y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:59:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086394; x=1615622394;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=nd/MRjJ/QhaEEZUEZuJJ9RcShOWWT/zGc5tXcTNkZRI=;
  b=j8t7tFGf6auVA98j03+tFQxnMZdqsj4h7I6utLDn86GorJNtV1D4CJhe
   TMGHG3ambcnPOweOl6O2qhiO3oD12/Of3ayFOC45s1ymxeq7wKWLJU0X5
   Ndo783bc2Ie9GSH2fy6GNybXWYw9fnxWlX1EetMO1a1hm1r7k0/4FzQgp
   g0rdRn0Fmc/ucHQ7KH80GKCp4bvtVQm7/ciYlfJeDEltA4YMgvg+iut35
   UahUJAWykUjigbFDIBUWQMubcUurTtgs2wJUJWZHaOWb5HXhjNmf+qs7L
   6VvqIfYZ89OfRUJvp0pLUJx1MDjdoCb/83nEY9yJJuM57LVXvMAg8kAB3
   Q==;
IronPort-SDR: +mkfJxqPlDhGF/trQBjO7SizaBsFNGdmiJTUYJ76+l9YupWlX6K6+nunciiaNlVmZy5IPSxZ4g
 osyMefVsY3V8/OvU6Lzma9FHnnMzQVwB8zMWQyR0GqNRHuroS/lwhHU/pIDS4AMhSBg59envMf
 PebZI/ZmP1ium6C+2MrM/n1XEfX1kkJUxdAknf9uJFMsdzXtcQoPElZ4tzPSUWMLYiICusrlmV
 KRXqM8e6HNcZZ7o+Xl0P2K0NhaWHlC5iekBGmM/6wUFJONNaeiIRjoj540WV3QVn/izgKeIT4n
 I9I=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132374966"
Received: from mail-cys01nam02lp2055.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.55])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:59:50 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=arsmVq4yrE8g3a8xnHPVRgko4pSQu40CpJWtKQpouy424B2p7rW2oM5Jef6l/JSX2ZthLQaCcxI/+JEC8N+WmhnpZausIV1tJRmSMNi0R/PgrBNYGFfUuS9bBQBVXN30sszAwYxFILHia5Xl1U23VKt+A4fkwUWsrKba97P9etesHZQm9uqEkpzkXH1IbF351vDj9cLzZob1TReC4Ahg9ZGoWKfkbI3uon1G3ZYieEzlkuOnf0hiIU/AWy6cY82z1ahwFojv1cHfmYajIvpYHxd++xg7TILdtiwd9i9maeVw67ws5c/j0JA9Nr8mpngLEJcYmmq73czA/0wQL/k1AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pELhePTPn8l4qp+9EmcVacRzVNBCNI68CwWUhxT8gs=;
 b=aWmeBYQIkqDF3K6p/10yV7/cYUDw/gmDtwy6t9rjKmq+NUhv2RGbEXs7PHWWo0Xn/G331MBTmGyna70vYk9hLOkOfcUFViUpEJ2dwimor1SSk5d41aStJ7OyDYmKBJ0hPvYSIJy4TBF7Q27Gl8swhmMjj/wYGy9ahiwqrF0P4ErkM860Fl6V9VjCIz9dcN4tkmO4SWKuHrNPsWOm8v48oVStmopqvSZ2i5hO1iu+XVc9QMpQryptxi2OY198D3l4SYIrWLZLRIwWYGgLq8CkKV8jb8ttOEXpi2kTJS5rO5p/vF7uBVUgi6Ttl6jgA5C4CTy5JupwNsvFZO5Vu7K6DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4pELhePTPn8l4qp+9EmcVacRzVNBCNI68CwWUhxT8gs=;
 b=SA5hU7i5/tkbW5ImB8E/0TPBqWVvv7xVyryO3ACx8unxQxv2rypZt8YjNVVdZ/LQx1pXqDwvlr2r+8pimUs1paBo/8tc9BZnThY39DFVgdQiaQAjidk1qrufMmWoxIXNZV1BLt+ApyIPLlOZY+aeI7GyHK63Nj0XJ2hIgvs2xAo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6944.namprd04.prod.outlook.com (2603:10b6:208:1ed::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14; Fri, 13 Mar
 2020 07:59:49 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:59:49 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 20/20] RISC-V: KVM: Add MAINTAINERS entry
Date:   Fri, 13 Mar 2020 13:21:31 +0530
Message-Id: <20200313075131.69837-21-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:59:42 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ba8a6394-46e9-448b-7bd5-08d7c72480c1
X-MS-TrafficTypeDiagnostic: MN2PR04MB6944:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB6944B57EFDAF8D633551ABA48DFA0@MN2PR04MB6944.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1303;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(199004)(26005)(4326008)(44832011)(55016002)(1076003)(8936002)(478600001)(86362001)(36756003)(66556008)(16526019)(66946007)(956004)(66476007)(186003)(2616005)(316002)(7416002)(6666004)(1006002)(110136005)(8886007)(8676002)(2906002)(81166006)(81156014)(5660300002)(54906003)(52116002)(7696005)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6944;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QuE3js6y19XO5GgEEQYiJha7VIk+yM9UujbuMicW5u/WrDSMu1njtmR9JEtke9d6bAeFyvHyWAnt37Hgti6db64vukRJy058fGwwjgfUK45zzLMS/z077KaPkEqxnKVubHxXBZLdoQwHhIbeSK06gepaodZ7TM/eqrDaZXPl5q+/BR7Gg0BDbaQOix4BJsGvIKB/CD/dPY3ZgFcmQh7ldjvs4gtIQJfXDspHh5a4lxt+SzkqzMYekwRwn460HD28z+59w2w0M0jDW5PuvTfbskNwBzl5nqSXS8WtihQn85BECl/iUWwv4QlgBaqUDhKjT/Whb35VopCbUJQ1LTIcksZdQ2MS+2/iEhMpVdYEsGbzRmjeNbz5BP5SOi5pc/JcR4DNg+CMxUIKD/1ybin5Q1T37Yxw0qwOJfhlqaMeGSksJFuiCZ7YvPvCPwk6IkqEjGZJqMVGQ1p4WvL4gsdqlRPo8J7moNHRzP04ew2P/Yrte/i5MuTxW45zTd4h8Rx3f0GUOI5sBUsX2KjMxeckww==
X-MS-Exchange-AntiSpam-MessageData: tzHKRZzPrLKsjGG9ONGOcrQ1B/Iw65qEsjG9+D5Gi5lNE9UE4jO+Ra57ZaCu1yMU6e/Fk6bs1tqBfmmLMFSC+WSDUzE3B7hUWdzO6UnxTsnISt4zJKG7CLb1YiiBmmzjDvkdQbdF87pOYUZPTD1kAQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba8a6394-46e9-448b-7bd5-08d7c72480c1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:59:49.3885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BBTx2I0igOPkwwxm6XKz4xOm9nwFZ0PWnOKN5R9VGK3jL+FrtTxwSY6JsQN2bi3IIAjXomGkYHFzksu/SArw0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6944
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add myself as maintainer for KVM RISC-V and Atish as designated reviewer.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index a6fbdf354d34..c149b5d0f5fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9201,6 +9201,17 @@ F:	arch/powerpc/include/asm/kvm*
 F:	arch/powerpc/kvm/
 F:	arch/powerpc/kernel/kvm*
 
+KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)
+M:	Anup Patel <anup.patel@wdc.com>
+R:	Atish Patra <atish.patra@wdc.com>
+L:	kvm@vger.kernel.org
+L:	kvm-riscv@lists.infradead.org
+T:	git git://github.com/kvm-riscv/linux.git
+S:	Maintained
+F:	arch/riscv/include/uapi/asm/kvm*
+F:	arch/riscv/include/asm/kvm*
+F:	arch/riscv/kvm/
+
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@de.ibm.com>
 M:	Janosch Frank <frankja@linux.ibm.com>
-- 
2.17.1


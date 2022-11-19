Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 122C3630EB1
	for <lists+kvm@lfdr.de>; Sat, 19 Nov 2022 13:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232799AbiKSMaV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Nov 2022 07:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKSMaS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Nov 2022 07:30:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CED240B4
        for <kvm@vger.kernel.org>; Sat, 19 Nov 2022 04:30:17 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AJCP2HJ025394;
        Sat, 19 Nov 2022 12:29:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=5nAq210glcspJMzuimImYlKqNANwK4iKBnAOxZ1+7y0=;
 b=G6L9iGVm+AaESpUPAdF70cupb6A9r7QIM/n3BKNVkFn5uL0L3ziAEP5AVnxyCzELx8Fb
 lHzVD1m1JcDa66aOjtc5Fo/SWQnLBHto6wu2/BAVwk/gt00LOKodvH7RGhnwtNi/pTdt
 lKD063aV2/7nijoUF+IMQLrXXx15t4aR6JWetQWN/xVinkN5yENreFaCWFwsFkKiTDEf
 p2efHwU5vFyNUKczctiDZafK2HCjVHgP3iRoOTJut6w7ExUnt+ptJkJMYJf6jlsBBy8A
 p4v3kdD73SaTHTJ/mPG/VZ6Ob+OFmfTD+9HwRuZpZGUa7eS6fA8wTXx8UQRPmcBd/qbZ rA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxy4e003f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AJ8N6E2028055;
        Sat, 19 Nov 2022 12:29:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk7mefq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Nov 2022 12:29:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bE0eyZw1kuKPfUU969L2HGL7tr8yV7Zj+pAhMs8tOrZxwGKBn0flFa7UTJjW1KAf6KjWdgjT43vpnzHW73UprXS78yRSXv8+9x4lWew4DNQuPebtvIDE73dKf66LboEV++p7s2gCd1OwObzv2UphE97kMnQrODQv6JQJElqdMfrblimvvvTSZfNbJnW0p2c6hdIS7GhuzgoysUrFDLKZzIXW1PB8kvXmZhDeZ0pkE/HQ1f3+hRNgQQDQ8aOF02JHrkR4UJeazylUA6KFKt3/Q1ymG9ODpexrsWqWAk5pnYtDukpApSDPWa9DI94fWAqGWEOIZlEnH2GA5FeD2g6Gdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5nAq210glcspJMzuimImYlKqNANwK4iKBnAOxZ1+7y0=;
 b=Xxxos7MT24AaN1cznZMt5VOcfZljyxaH/9TrpE3YItkdGmRrMaj4ovzc69rAFlxaAjrVs7gJFlOvskBykmktkqDG+wF6xfO4++SbTE+Qe3h8UyOro+NHsXdA4FUfsi+zxwlxiSYtsbaQ4damniL5FHIHB5qYJzOEs8s51SLHc7s7EJwdu7uHbKEA5v7v/RvxR++zdlzlcKfiS3aT3u0HqdW0MOTRJBKsQ3MOORpu7aOwDYrqP5W+fP0M/hG3QMGMBMj7ONDIc46WVcXJ56oYlkTnTlanf8m7wvYqM1/4I6hYy992AwbtLlTwoJeMBwP7Gp1Aoya8MdirYMvUpQnEmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5nAq210glcspJMzuimImYlKqNANwK4iKBnAOxZ1+7y0=;
 b=JRF/0QEKSkPqW0ELPOuSKZy7Hde0FK0f881jfnL9HZKHtiH23XAx9FXF9zqcn11iHfdAMnMkk12elTGD+6EEHal+7tkG4xhIH9zg92XkiPybOlingN/lWRYEaH/psMXIUtnBr+AfhrqYofYNJVOvlBiHzMYFEhLPH+572M25/Uo=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CY8PR10MB6443.namprd10.prod.outlook.com (2603:10b6:930:61::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Sat, 19 Nov
 2022 12:29:12 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::cf3b:2176:14e5:d04d%4]) with mapi id 15.20.5834.009; Sat, 19 Nov 2022
 12:29:12 +0000
From:   Dongli Zhang <dongli.zhang@oracle.com>
To:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org
Cc:     pbonzini@redhat.com, peter.maydell@linaro.org, mtosatti@redhat.com,
        chenhuacai@kernel.org, philmd@linaro.org, aurelien@aurel32.net,
        jiaxun.yang@flygoat.com, aleksandar.rikalo@syrmia.com,
        danielhb413@gmail.com, clg@kaod.org, david@gibson.dropbear.id.au,
        groug@kaod.org, palmer@dabbelt.com, alistair.francis@wdc.com,
        bin.meng@windriver.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, iii@linux.ibm.com, thuth@redhat.com,
        joe.jin@oracle.com, likexu@tencent.com
Subject: [PATCH 0/3] kvm: fix two svm pmu virtualization bugs
Date:   Sat, 19 Nov 2022 04:28:58 -0800
Message-Id: <20221119122901.2469-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0335.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::10) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CY8PR10MB6443:EE_
X-MS-Office365-Filtering-Correlation-Id: df3fdc51-e440-4222-9d02-08daca29a9c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4qc3I9xRiXwnX+8K9I5WnFIjaMqLcE66Bba0dPt9AAmdZYTd7XA9YL3Xmk9ip8CvgFXKqQttp2kobUYpXmpdM0AHYw8Tg3ELGax5mV1w+aH9Xl9xzExKxjK9MB5z8TWyozEemfQts3XFUOeNbp1aYs0ghIsCcVdziuVk4sj6Ae3EU2NcfYimhI8pSkY89D4SMMwPHJIKVCUiSUopDlV7MxaErfzLAvfNsZYROSMOmqaZhkbkNLuk1DGEpMeifLXpFJIPXT1cNt/n1gGXFhH3T9Us1DpV3QKP45lXYm6s3Loe709kMQrHIiaSVyumCOqlcsvsn4vnqUwcDe5EBdFBiNImtmPPEjLP9FB/XIb36C0W6vYkH8daAIs6O4lSqf7HvrynfzVNk0HL8AxXlMvKnehdLuQ0K7fmWL9/PDB3HWLZvZ5z93983DEINGKoNYVUQ/1TgMjbUDb84kteNaSh39lo7l0sWAReCzuOntLY/e2zDHoE8gKh0SzHQB35781+kLlrHL+y4e+DUE/BM7ykG/hOpudq3Iydnb9CfmdsrjBjIWJR5TSy4QO2EX4sSh2VfAMMVh0DXFkNG4efjXDQeEOM1falZTXr92r2+tjQDahNpF2eFb8GTWlXqc3NdrGs91hzQmdqJbjJnUP+4CHnbxSZNsxeWodS5/VTQ74mmws=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199015)(36756003)(38100700002)(2906002)(44832011)(8676002)(7416002)(4326008)(8936002)(83380400001)(86362001)(316002)(1076003)(2616005)(186003)(6486002)(966005)(478600001)(66556008)(66946007)(66476007)(5660300002)(41300700001)(6506007)(6512007)(6666004)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IetVamL/7IAUlAk38CbGnjX+yteLJzGlm+WaIwXfly9BHJZdOBcY4ZYFPSZV?=
 =?us-ascii?Q?/vHw7HHBjvcHMCoziyewxG88BHSkp5ty2JaMDAEkzCa5JLg3VvcPi8eIjl9S?=
 =?us-ascii?Q?TvrfytiCpJSiOHUYeK3t678hCUMM+P1HdHImvYfNwjl1PIHRgt+yeWJIejVZ?=
 =?us-ascii?Q?8wrvKfOhjdOSfNUi5ka6LPZnzdPSZPY945oy5milsVmuDkCgDzOOWE9jJfeM?=
 =?us-ascii?Q?V0Ny6UUW9vnVkXkj0AyMlLfnNCCMEVsp0S7k3jKoxdzOeJAANQNw7kO6pIdI?=
 =?us-ascii?Q?HpGjjsjNA1hZeF9SFNCZiehzMT55U/JjVAkDIYKSyv44Egqf0r6xk+w87Loh?=
 =?us-ascii?Q?BdGtHeJ/LQeUyo7jmGOezAxaeGJ0N8NR9LUHIUXvbFTOs5OSrHxncRpXMY4q?=
 =?us-ascii?Q?VnW3wtJAUhzTjqL8QSny/5IuvzVYMSOxrtOFkO+4iRM0gE7+C9cDpfSZKvUO?=
 =?us-ascii?Q?o2dCc6uDoIRLjW+SUixVXgHuWvaRP3Na4O2Jwj/evvvqUnaaO3wFyHJD4BBd?=
 =?us-ascii?Q?tSdN5Bms4g9JfencP3Po/82rsBkYXlD/deayZgojnjx0s0xgcIymoj7Whpnk?=
 =?us-ascii?Q?yy1USgfUpFTPmDGLhOxt3NYGxthgZrQP00mu4DHs79WbIbtiAYWTDm9CYIJ/?=
 =?us-ascii?Q?fNyfopqvwGyAfn5QgTWjeECVtPXq2RzIwxJPJZFx7FpEZf/ZhRJf7cbK513m?=
 =?us-ascii?Q?eet9aHXSpDYbAYXf93NGvGDDTE2f9Ohs7biZ6bQs7Jg5hTzdUl7No5czwehq?=
 =?us-ascii?Q?1lffYvSIb+Gzala7EryeiaKtCfv5Kks49zkr2Rl4ypjtfLA1VS4OEMokwvkk?=
 =?us-ascii?Q?wrL246uQAwMndBwh1dA9P4C7ITVk/aV6gCX5e7yGyhnvcjn3DJULml2u+FUS?=
 =?us-ascii?Q?H6M7+OtU/20wDPHm7u63+tX61Vtlly1i4yNPJEtT/zZwgYyj7mhZhPGQFdsj?=
 =?us-ascii?Q?mbck8catAfwsP14xULEj4b3j1ZcGjfBJWYtgCBodseki3W0mtqDU5xvREC3S?=
 =?us-ascii?Q?UztQOZ357XM0uccXqh0VeeeXLvrmdbmnlAyZ8ILkPEjQynwdl0YkML16uzCJ?=
 =?us-ascii?Q?sBtvyXrthHtxvtNbE0VIMb6jGqPe7nq2oZvtM3Tx5rY7kLzzza+m5R9mHAsC?=
 =?us-ascii?Q?q63TKMvnNcOCUgjeaaxRfBfQT94Zeg8N5JrTGOvBjyLCLG/Q1M1bgv+fYscd?=
 =?us-ascii?Q?us4Nv3PXmcnrKuRZEnR3+01IZgmqrQqz/RP9RHE1s8ueZiTybOGmA5m3q+v8?=
 =?us-ascii?Q?+/pGT/XIUD4APkGF9KKbZFTbl9OKzUl6wgWDlz+LlpKfhq6/N8bcYmhSRrJz?=
 =?us-ascii?Q?A5J0MpCKnDryyLj/IyB6RW4yTXQGB2CHcjHQaodahxxV+kBp97wIgWlXG6q1?=
 =?us-ascii?Q?Sc7bAV6H9zuEx+okp+yD2sOHBJtlcVirwiJ8/SnssiGzXFh199I0LwllrZ7t?=
 =?us-ascii?Q?kQcFO1CDcdnLcZKyutJiTqr0mrE/4KahVm3fJ2v3A8ASaGh5dmdSeozHt05l?=
 =?us-ascii?Q?ukR0Hy7Kt9U3RiFcQTKaztZ2yxueMn+Pu2qXeY3FXe0dwEk3Pql9NVBVu60R?=
 =?us-ascii?Q?hvXi8xOF1tq9XpJc+OFMe5DrpvMIpak8kTrUD36h?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?i8covhIWM8M4i+Ve/LQcKM1fBrWmylSw13OnGmILSgJKKTiXjGvFvQ702FSX?=
 =?us-ascii?Q?QfrRPBjf9yFVkUMvPr4rTLY2tOkL7p7iQbS1A3Ti+kvstLZwe9OpkxUvaepj?=
 =?us-ascii?Q?NpI7fXRRe2D2UVjiMdPzT57+mLdsxwXgdLLzzx6OKnlPCWrZXKDyTqCrh48G?=
 =?us-ascii?Q?Z+iEOCL976jp0bwtOqx/lS5IlNo+wwgd7s208Y5s5h5Tu+Lr5V+6+vS36T1g?=
 =?us-ascii?Q?bP2bjS8kCMsN+gYNB+VHK2VutwFHK8l7G1Vz2eDM81EZTYQ2I4qXXviqaBPp?=
 =?us-ascii?Q?BWwAQ9R781w2+6RNuiQtwRSZEhb8vJ8ByD3vMTRTP72BnwmxxUyf1JTCQk2U?=
 =?us-ascii?Q?AtsGlO4ypiKQcp2WDG+xvpHuXXj7BdFq8CdK/XQ0fTLd7/07e4ujhy9uCw6u?=
 =?us-ascii?Q?oQeIwewzsUDoxsOuX9xz76MzycBKnpARLCq5/LGgWcjiUVnNC3FlyhmKP99E?=
 =?us-ascii?Q?Y28ScR2/R3/12T2wusn4y4OTGWy4maTlz5xrTYe9RjVWmDML/R7ZEk7yMonS?=
 =?us-ascii?Q?KuQav3RoXqNVxm006Jx/M6xAFDz0z/2X8P/1kN/TN0YHSSgON0yufbRbLIMw?=
 =?us-ascii?Q?twi54qFVp4CV9umzqqLFbJWuYPS09bsHyZxQuW5C8yQyhDDOez6UDVBeiGLW?=
 =?us-ascii?Q?LptW356uaD+QozzbcjY1YaXQ2czFokkit2qz3n2xfVqmXx5VDxae1v0G5oPW?=
 =?us-ascii?Q?/lQVrQd9l4sxo9eO7zGhRktPdvd/X599Nt3xAYBILCEFrpmwAD4OlvMtf1YG?=
 =?us-ascii?Q?ubs/eWR6IsKqGCFLCKWiuaeDFzXIG85uePr83xBO6kgKINxGDj4SdC7vAWJY?=
 =?us-ascii?Q?HlSv6X3mNUsXvkEziml5I69pO+hXtLhtbaa3RW3bhARtIDKPtuqn3F+u9Jks?=
 =?us-ascii?Q?hE9BRCqd3fHV3QVUtfABGFoWw1gJdd6FMApi9bqG6W0BCH+J7/VV5UAIwmZ8?=
 =?us-ascii?Q?mwVvP22s2bq7S0y2KmRqDUu31Aw0V+nWTz4ycS8oX757n8lmdPP5HLp83FGh?=
 =?us-ascii?Q?BCn/WSd4q/BKdRHo7FHMuC/ZyZcdogp4xeolVUdTX34vJI5NNF92bpUU3UDA?=
 =?us-ascii?Q?rbAXJkv2KFtISn21CM2DDmEAkI0cG/ECbEah/PXqMwjNNm5f0W391yP0eJL1?=
 =?us-ascii?Q?7amDy3bcjlWHw3lpkmZDWCUWXurmRS9cZ+uRrh327jzFZ6oTccsW8H6ZXEZw?=
 =?us-ascii?Q?+l89RU42bJeUYSv6DPnuJ/cQxdvmR+FyKAGnTKWirrIRAmXFHTto0+fU/fet?=
 =?us-ascii?Q?sLbeep2/jUhwoVVmYVv1+e8SGbOHBJZRCZnsTa+Edka1b0dFbEMjggi9oDco?=
 =?us-ascii?Q?6aL5NWuay95FVlDQ3WvMuq92PRopizpEbuxKqp08E9GjF2hajKExEuskeI97?=
 =?us-ascii?Q?DxNGFN3RYK7Rvnm/NfB7SY0mN0J5BNdpK4cZc8JsKxQLvYESczQTRSwEnMGi?=
 =?us-ascii?Q?o7z4b2cP0nZCNuf1XAOsqjgA0L5qjwhfNE8jk2JuP4mecV24T2Kz/79b56kd?=
 =?us-ascii?Q?3GVYhm5Vh0y78wkir0x9i/0R1IrbZGgFXqtC/P201UviAJaSgDv9fU9oBjGD?=
 =?us-ascii?Q?ErT1XFLRWsb4i9YkLTZnUkZ/u6XLnLFhwcSNtQGFiDpV9XIce6KcCYZ8Vpsl?=
 =?us-ascii?Q?ig=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3fdc51-e440-4222-9d02-08daca29a9c9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2022 12:29:11.9722
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZfAfRSS2M78bxmGZZeD7BjB5ldp4jgo1nUSNio4yKd175y+ivoc1Zayj0xwX2t3anH8YyHLP5PcsNNbXC3VNaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6443
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-18_08,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxlogscore=938 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211190092
X-Proofpoint-GUID: WKy90SXqG4PVQDzqwshzgelY_GTkZK_H
X-Proofpoint-ORIG-GUID: WKy90SXqG4PVQDzqwshzgelY_GTkZK_H
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset is to fix two svm pmu virtualization bugs.

1. The 1st bug is that "-cpu,-pmu" cannot disable svm pmu virtualization.

To use "-cpu EPYC" or "-cpu host,-pmu" cannot disable the pmu
virtualization. There is still below at the VM linux side ...

[    0.510611] Performance Events: Fam17h+ core perfctr, AMD PMU driver.

... although we expect something like below.

[    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
[    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled

The patch 1-2 is to disable the pmu virtualization via KVM_PMU_CAP_DISABLE
if the per-vcpu "pmu" property is disabled.

I considered 'KVM_X86_SET_MSR_FILTER' initially.
Since both KVM_X86_SET_MSR_FILTER and KVM_PMU_CAP_DISABLE are VM ioctl. I
finally used the latter because it is easier to use.


2. The 2nd bug is that un-reclaimed perf events (after QEMU system_reset)
at the KVM side may inject random unwanted/unknown NMIs to the VM.

The svm pmu registers are not reset during QEMU system_reset.

(1). The VM resets (e.g., via QEMU system_reset or VM kdump/kexec) while it
is running "perf top". The pmu registers are not disabled gracefully.

(2). Although the x86_cpu_reset() resets many registers to zero, the
kvm_put_msrs() does not puts AMD pmu registers to KVM side. As a result,
some pmu events are still enabled at the KVM side.

(3). The KVM pmc_speculative_in_use() always returns true so that the events
will not be reclaimed. The kvm_pmc->perf_event is still active.

(4). After the reboot, the VM kernel reports below error:

[    0.092011] Performance Events: Fam17h+ core perfctr, Broken BIOS detected, complain to your hardware vendor.
[    0.092023] [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR c0010200 is 530076)

(5). In a worse case, the active kvm_pmc->perf_event is still able to
inject unknown NMIs randomly to the VM kernel.

[...] Uhhuh. NMI received for unknown reason 30 on CPU 0.

The patch 3 is to fix the issue by resetting AMD pmu registers as well as
Intel registers.


This patchset does cover does not cover PerfMonV2, until the below patchset
is merged into the KVM side.

[PATCH v3 0/8] KVM: x86: Add AMD Guest PerfMonV2 PMU support
https://lore.kernel.org/all/20221111102645.82001-1-likexu@tencent.com/


Dongli Zhang (3):
      kvm: introduce a helper before creating the 1st vcpu
      i386: kvm: disable KVM_CAP_PMU_CAPABILITY if "pmu" is disabled
      target/i386/kvm: get and put AMD pmu registers

 accel/kvm/kvm-all.c    |   7 ++-
 include/sysemu/kvm.h   |   2 +
 target/arm/kvm64.c     |   4 ++
 target/i386/cpu.h      |   5 +++
 target/i386/kvm/kvm.c  | 104 +++++++++++++++++++++++++++++++++++++++++++-
 target/mips/kvm.c      |   4 ++
 target/ppc/kvm.c       |   4 ++
 target/riscv/kvm.c     |   4 ++
 target/s390x/kvm/kvm.c |   4 ++
 9 files changed, 134 insertions(+), 4 deletions(-)

Thank you very much!

Dongli Zhang



Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF41152991E
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 07:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbiEQFlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 May 2022 01:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiEQFlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 May 2022 01:41:19 -0400
X-Greylist: delayed 5536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 22:41:17 PDT
Received: from CN01-SHA-obe.outbound.protection.partner.outlook.cn (mail-shahn0099.outbound.protection.partner.outlook.cn [42.159.164.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2A9275F9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 22:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pd3QiR8t7bZtqV3QDC2TuYWJ9eHrIp0pCNm7Bh0VRq84pjE6ibWjQrOcqmpW2XGL9TWx/MetIgz66wcvhZExbYr6y9Tfh5Hl9jp2AT3TjGK9fBb3cm3CPRFn2/1SuvKMdaYccRhtkH3dWZXI2Tx27i1Luoi+/5RseZp5rq0EVqwqGk7xTFfCfe+6VT0UifmTu7a5vx8S17yiNG+MiB+LIW+WZMIiPRjda6VdDKGgtdoSUNTeQuNKT001W8vUe5YKjxQRZ0ZmCJC/+VcopIQhp6rwoavapSahhRZO/Yerm07geubHjjdiqAUvEZP3r4EO7Gkbt18CCjZfoiO2dtRx7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0bN2yFrDuIMFF+d7QRyaVBLs0/VHZTrkLthID1smys=;
 b=Kd4RCu8jjz2eZzqOAo8b1moNOoQ/rq/yHn5KdzWNP/6VZ4bXN0dLdJvwa1VLyhpPqB32doQl0FvALYSoDYbwXfEZC7SiC0qD+otLuUn8dlNLaUl+It91/xdy3rc2UHhBVG2EqRllWCXBwCY4vD8Qz25Djjt5OB45AxVyPiIb1ol4V9tCQDNf+jwbYYSIXIj6HuISJRniEm0XheDPYXLqIf0jKqFI+tngmy9m0XFiyvGER+w38hOOazIghcayHu1YAsOOnGuXcdBY3Y+vlY+GOYF3Adzhds8b+efVuljsZSjKTU5pFNzFwbpz6GrbH134Q7y4fw4ajg7am816Pwt40A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gientech.com; dmarc=pass action=none header.from=gientech.com;
 dkim=pass header.d=gientech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gientech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0bN2yFrDuIMFF+d7QRyaVBLs0/VHZTrkLthID1smys=;
 b=IwL1TAwueuSsn1OSYJhFLpxGeMA9AKhyJplTkr4AF8+54eS4T21CR+1jGcmEiZsYMv5Z6caBLGZfsROn0zJ0SRv/+8hHHDID/h6aruNhGOqDxfE0tDV30o+bi/YZDltbCY2f6xCJOMHtfseNp7zH1CJfZIbWb87i6T4FTIAV0+0sEJJNLwt9JFu8DkkvQhzpbgjwuWqSBdRpfm9JYYJ+2W40APNaxSP+pLuXA6opEGc9WsZx521uKu2ekdW9birO8vDu9auty8HMStcy5aSzAcoi5QsdJSw/SpykF21/MtA3lpOiasLnrkNMrb87fnnb/YFGT+2auqBLzLf4cT+Mww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=gientech.com;
Received: from BJXPR01MB198.CHNPR01.prod.partner.outlook.cn (10.41.52.24) by
 BJXPR01MB168.CHNPR01.prod.partner.outlook.cn (10.41.52.18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.18; Tue, 17 May 2022 04:08:57 +0000
Received: from BJXPR01MB198.CHNPR01.prod.partner.outlook.cn ([10.41.52.24]) by
 BJXPR01MB198.CHNPR01.prod.partner.outlook.cn ([10.41.52.24]) with mapi id
 15.20.5250.018; Tue, 17 May 2022 04:08:57 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Re;
To:     Recipients <youchun.wang@gientech.com>
From:   "J Wu" <youchun.wang@gientech.com>
Date:   Sat, 14 May 2022 04:31:36 +0000
Reply-To: contact@jimmywu.online
X-ClientProxiedBy: SH2PR01CA028.CHNPR01.prod.partner.outlook.cn (10.41.247.38)
 To BJXPR01MB198.CHNPR01.prod.partner.outlook.cn (10.41.52.24)
Message-ID: <BJXPR01MB198E0C95B5095C50C758300E8CD9@BJXPR01MB198.CHNPR01.prod.partner.outlook.cn>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ef64b08-063b-4b86-50fd-08da3562b03b
X-MS-TrafficTypeDiagnostic: BJXPR01MB168:EE_
X-Microsoft-Antispam-PRVS: <BJXPR01MB168D97458F0EAF55162674FE8CE9@BJXPR01MB168.CHNPR01.prod.partner.outlook.cn>
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?HNulveMYDZy3kP/m5KoR4zm5bzzdcPAAGcDFb9OxHIEq94OBRWsxLUOsBh?=
 =?iso-8859-1?Q?DCOcg6f5p8Kr722XI1R3olc2G1dLlIKD/TMXKjXmlNVbtbYe60HanYjadU?=
 =?iso-8859-1?Q?1D163o0++Gm8wEH/v8HbN2ENphYz0ZvCcQO4GuliomZgdzZUIw829KftvY?=
 =?iso-8859-1?Q?rZsUyVWJNM3ylMO5C9JcHqtu9QvFXRq2JikYFdB9Y3n30W5dtMXChPXPhL?=
 =?iso-8859-1?Q?2PEgQr41Kb/DJ4n4/h/xB4mdC5MsGAAe+uLSGo1zvzEK/JzYSBK+hVfRXo?=
 =?iso-8859-1?Q?IY97Z4tyXcCYU/hHDvm2o8lfgFYONtvQdiSaDV6XNDC1XIdVpBlM69XeU5?=
 =?iso-8859-1?Q?jFmgSU3Sip/SOY2U3WaGV+fubpAlY+ehofZBftPCDfIAqnEXive3mjhtGU?=
 =?iso-8859-1?Q?YuwX3r8Od8ynWl8vFSPMfnFxT49Glf9zqO6vsIOIJZf+jBF/CPmzMk7FKP?=
 =?iso-8859-1?Q?vjvpJZSmaT1fxLY28BJ68gEDA/hU290Io83+pzTAeFcbuBeqH6ZyaS791R?=
 =?iso-8859-1?Q?owPJYf10MPGvL2OtZA4jT/zD3/x/A05LZ8rcizMRPyyWh1wzSH7hUoJSaR?=
 =?iso-8859-1?Q?haq8R3kd9wAFUlUfzmZvGugo5fCvGGsfbLLl4wUEv6sKD8gRzJPJtPlTvT?=
 =?iso-8859-1?Q?e9anEmrQZfOtJLyJScqKJ3s2bbYjIfwpaehwFldXi+JI+C8JhA8RzYfibf?=
 =?iso-8859-1?Q?RSmBrej/KP1WipsWVm6W03/F2uJ+VdicQ+y1i8P9fdXnXpFXj2KzRbyKYs?=
 =?iso-8859-1?Q?Flfa6iA92hu+O1WsV1KghUEJPtAXzGicwWyaaPsKgEUGSL3yjRORpEKQ6l?=
 =?iso-8859-1?Q?0w80feSIIk0UZNVZJJhEgOrdB2C5gNNFcK0VWXLc+XfX3kVisOfTJcu+KF?=
 =?iso-8859-1?Q?ysHWHGhyCGJ0zrVVKmEUYuEtz4yaBLeN3X1he4ky5YjPyJTPdaEGMWPByl?=
 =?iso-8859-1?Q?AAfQ/ffYGjv84ppTlbRTGyZh3ot1/fKYl51oeo02QO6MRKwxp2Fwo3lKbK?=
 =?iso-8859-1?Q?W+8+R4+1cjDF3d2HFnR0HF9PiD/XGmyVpCmlqDF4pvWruwx/9KGKs7a1DA?=
 =?iso-8859-1?Q?Fw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BJXPR01MB198.CHNPR01.prod.partner.outlook.cn;PTR:;CAT:OSPM;SFS:(13230001)(366004)(55016003)(8676002)(6862004)(66476007)(26005)(9686003)(4270600006)(33656002)(52116002)(508600001)(186003)(7116003)(40160700002)(7406005)(3480700007)(6200100001)(19618925003)(7416002)(7366002)(38100700002)(40180700001)(2906002)(38350700002)(6666004)(7696005)(66556008)(66946007)(86362001)(558084003)(8936002)(62346012);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?rhDxXwhazEyp1IhiTrt9vlrvddN9VZsOEF3f1J7EoUVxR8saep9SQcaHVr?=
 =?iso-8859-1?Q?IorDJputwGKUg5CMgMVNEe0AVHo+TbI+/+wLBvLyxHUZIwhE/P8p7mHvnz?=
 =?iso-8859-1?Q?d6ExU9Wx1Nbg5XUO4uXsg57LzbcEtIMGKctmfzgiTC0WfvuBK21RuxMM58?=
 =?iso-8859-1?Q?TV4xkTsD3SKv8h9+J73+LTFoFd9MiTnM1qItBHE51CboE8eh3zhm+0m3GX?=
 =?iso-8859-1?Q?rkX4LwMPsfnjgeLoK/y9PP21ZZjIxzoX0Nq1062P27EO4Twnz7Sq+61m1W?=
 =?iso-8859-1?Q?1Y3neMLEe08W5q6CFVBrv0MswZvY56QwLg9V5Tdwo48wY7ouFlnwZQRJH9?=
 =?iso-8859-1?Q?lLkfiTS7Mtv1/d1ElfSxQm+ZVu1eaKRzeeTST4gKwtZM5FJykRc3sKsnqX?=
 =?iso-8859-1?Q?q0cyFC/qUIuLx5VC9LaimJF+YOvYW13P3hYa5wqbaWPhb0iUfO9ZkOmBmV?=
 =?iso-8859-1?Q?vlc2y1z7n9AwAWA3RxA91iCuV77oRSdd8tdGFiWmJZT0AlKwm7/I31mS0V?=
 =?iso-8859-1?Q?IZHBCy0cRIc4JkTPwwvVSn07aNtPgeaG36IpjeQrEHbSQaHHeVrnqodWmk?=
 =?iso-8859-1?Q?kao0TgAz2YcS7v7WK/ApSvvUqWIqoyRl2MbRFBPTqvt9IBto5NoPjTf8nk?=
 =?iso-8859-1?Q?h3oXjyvZbn9TDPOAgKO9vgaAqsuJZCJlp0EWpoQQEoOjYB/SvIkQe/7Wbs?=
 =?iso-8859-1?Q?HEmfacPuJCrDgGV7Zz9raPRfjXUD/WG7jR+T8D7fgnyvC58MTCC1Iyp6o9?=
 =?iso-8859-1?Q?Nq63XTAV/W3rXNJUg4FhIGretcCvDKGz3tbY1fxiHhKxQhoxaaYJHXTIYV?=
 =?iso-8859-1?Q?+HVIJSLY65yn1TADmCWXSO6WLFzPwQVEZZfXV/pixE5Ip4+1PqpvCtnp5Z?=
 =?iso-8859-1?Q?mTqNPBkOmvnRDNtEYmYb+S+nIgFszUGhejG7RyPlMWzfZkBf6CQbWhz7Nl?=
 =?iso-8859-1?Q?m7a0GiJopf1GaBCWvsqT50o3CkKR5bm27BTCc8LJXKwtw5yKUEpDgI9yGk?=
 =?iso-8859-1?Q?JA8DU7K2rdxAlACnqteaTnUnEu6LttstPKjMaLCAu683A3seeEFxExkUrl?=
 =?iso-8859-1?Q?ewHEAWjTyU86YcIQ4FMJtwKZrkM8wS6wrcnS5pbCtgfUdRAC3m8r73Vk+U?=
 =?iso-8859-1?Q?Sd8sdw8Il5zJYaZ8RLhUXzFwcd9WaJjnBIqkXJzc7qxdNRhPuIsbqxlpqO?=
 =?iso-8859-1?Q?n8nl0Ow+/mthjFkOtSSeFEHTiFe7NoDuEmyyLPBhs7/hx7qQrqaNQduVTy?=
 =?iso-8859-1?Q?JABPtSGjdQpaQPti133OkNdHUKpVE0daQlU7QxVjV3XbP95skbydjXQbfG?=
 =?iso-8859-1?Q?3K0QGCzIfGBg+uqEhyAPeWRol9j7icDX7CTgQ/F+ih9/p9XnvNlRVCK/6X?=
 =?iso-8859-1?Q?ENRoTltFCWMf7T/vTO4BqwWRmTJn1jhlstrkr/cMjSSTBEFk0SkPexJ9E0?=
 =?iso-8859-1?Q?RiiefwQdFHBKlG/9qJmAWcs7dWh50Y9eBhqX6IAJpgE8vkZPqiH7REg3Aq?=
 =?iso-8859-1?Q?7tE/ResrBb8L3hn53TQYIaeecuRNFVMK/zmlatvTVwzh0kteJEK7n0/slM?=
 =?iso-8859-1?Q?xUQhCGbK5V8BHHYOFxv0Pev2zQkCpJYe5R8mw0vliptGM+gOpfMq4Mjf1r?=
 =?iso-8859-1?Q?vdB7h4rI0tt1+YKg5fXe7G4FNrsbvTE9fDBz5YeyMhZWsdq5Fki4NhSFIs?=
 =?iso-8859-1?Q?LIOnnR43m171VlWywV5UmzqlKjCaaahyHMc/LdZ29EFvi4d6Q8y5zsxUIJ?=
 =?iso-8859-1?Q?FYEZYEdfSaVjJANz9JG4gI9WM=3D?=
X-OriginatorOrg: gientech.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef64b08-063b-4b86-50fd-08da3562b03b
X-MS-Exchange-CrossTenant-AuthSource: BJXPR01MB198.CHNPR01.prod.partner.outlook.cn
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2022 04:32:00.7653
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 89592e53-6f9d-4b93-82b1-9f8da689f1b4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3k/AsxvmZLDzVIFC2K27SxHh0fslcT3lSJ26nApKeNjnmGb4ttljj7KZu1lFtFq7kBsnF8F448ueHpyVGLpiZqnd9+p9avDoEuxE6s6+m7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BJXPR01MB168
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_50,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_BL_SPAMCOP_NET,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Can we team up for a job?

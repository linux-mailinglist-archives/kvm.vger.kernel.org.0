Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C03F7B5EED
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 04:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbjJCCIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 22:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjJCCIK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 22:08:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4758C9B;
        Mon,  2 Oct 2023 19:08:07 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3930i8kX005450;
        Tue, 3 Oct 2023 02:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=tnU/EeGABpHHC96p8FcVBGOZGYt/1LNVenyLh0ZoAqk=;
 b=K4ti2+O1yyBQF0xqPRx1ghOji3uNJJXzqS5jfsuuMGuMboJX03peigZd4iHnJcG3lJ5C
 kMNsI7IqmQfrgaS99lgSF9unQsvOIwiJyNk4qzyjV0xBL3lMMkH2kQRYZx1Vkv6XFqje
 j8fjOxwx9Q8H7VK2kj02G4Nmz94eupBujwaI/ELTCewdOszFpmdh1iUYCF5iIu9aFbuq
 lMz8rLA+bCZGVPMY7gQPflu94uNbS4A7fd8DLr+io2Lbc4PMANI+LhX4DLUPfaZlfesp
 A7wgmFcwKyusoKazbgba9KwSxsoeQX5vKvDk8korf+nINDYiYKtIgbcSll88Svh5L6CT iA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tebqdupwg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 02:07:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 392NHYR1002877;
        Tue, 3 Oct 2023 02:07:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3tea459qk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Oct 2023 02:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aaTz0TejKV4YvuTdBXWFeQ7Hu8H9FfRRQJaWwWsGwgZn07fj2xg0Ic3V/r5jj2iesGG9s3GppEJVQQSdUsz9/i3ATv3Cn9RXpxL3Kqa5356aDasMVGVNCsxNk96AgzhCs14rQyEZnQJ3dvMGfzv2kIo4pd0yUdC8bZwuMYKeRRpWWqKgzcIdwLFkqDpQUjZ7GINtCQZaLBCtOCZb/YPra1MoG0A6xHjO4fwDQxGeF86trLbFQNN1SCUDPrLOnCTksYkzkZriOz/skXLlyRCUITSCCsdKBQDai6/pbdz2IgiLNhdSSGYqu9OgKPsX9aD7GgDZV/svYdj8UbpgCqAOQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnU/EeGABpHHC96p8FcVBGOZGYt/1LNVenyLh0ZoAqk=;
 b=cs8MzArqtDEWSHwHOfj579fUe66xVXgCGx/cCEfVl7ju4Hlf+xQQsLJchQlE7sv6DZUWKplaV8RLSZ8C2Z7gAU4aQYpWBHnphsHBovatd20CtEFYpAr/DZ61JZh2PE04aXcCPA+rtcpUVqLhWpXSMLvDq7jefJBxc2qeLGr2xQSzCpS0xvJ6NPYM5YQA0H03PlhSKb7PY30v9HFcflpOb7W/bMw2J5kaheO/KBEbJZBfKCQzNYqk7j/j25yYw6xzbOZV78hhPJCQlfqMXXh5shP2vJXTR4SM3mpgLecnJkdJ+w34JyC5VxP2KoFMjaljVFFV+agnKiGCvWqvSJDCQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnU/EeGABpHHC96p8FcVBGOZGYt/1LNVenyLh0ZoAqk=;
 b=bVtrKJMYIEpYbSQ6kKoPlYhSOlI3ZrxKLHKsG5ZYU0mXrveIW07dTLbRMBIXDYjZB4sEdOOtEzhkqxmkDBDhFuM9Ge11UgT3xXgfesGgFUCZm4RPfmJ6G/rIwMZSlKAAphJLzutsmVauQuokL/q10k/zd5dXOPI3JJbjYMM4fUg=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by BN0PR10MB5045.namprd10.prod.outlook.com (2603:10b6:408:116::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Tue, 3 Oct
 2023 02:07:27 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6838.028; Tue, 3 Oct 2023
 02:07:27 +0000
Message-ID: <1326f47a-45c0-963d-d50f-a9774d932744@oracle.com>
Date:   Mon, 2 Oct 2023 19:07:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Joe Jin <joe.jin@oracle.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
 <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
 <884aa233ef46d5209b2d1c92ce992f50a76bd656.camel@infradead.org>
 <ZRrxtagy7vJO5tgU@google.com>
 <52a3cea2084482fc67e35a0bf37453f84dcd6297.camel@infradead.org>
 <ZRtl94_rIif3GRpu@google.com>
 <afa70110-72dc-cf7d-880f-345a6e8a3995@oracle.com>
 <ZRtzEgnRVZ7FpG3R@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZRtzEgnRVZ7FpG3R@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0047.namprd08.prod.outlook.com
 (2603:10b6:a03:117::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|BN0PR10MB5045:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abbfc30-0c65-4465-3d65-08dbc3b57dfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JTwqgGoY3qQUmohq8RvX7Q2biHjbaOU+rhoinlIPFi1+TPxdKjNr7QKIMgIAaMf8BPo3uL6XR9tyay8ykOpfpr2cdvX7977SgwPaY+YpKAxuaeSBW6L195Q/YfD5B7m1txANLtJwQqu7mScPQS7alueY5iBOPBR+OLD0X3ByMiyKxgLvG1ed2gfyqA+RN7OU+jUi5Gf0624dQ8cwKF5a+V+/740kslmLg37U5Z7ijpbDT1koHBtc+Qs2A+LlH0S4mlJYOvY5xqoCa+lLHdDMN0xGlspjZTxUw4bMFZZNi2bbELO4yupr2zy4seV2PGLlamrp9Vo5m0OHCZBRbLB2MhlIXQloDRKMJIL+k10SVqDCp4oVDp73LMRdOAKe/ykFxMMrQE7ZR57YsPSQxVZKHzeuEhokYeLUti9SMZIoLWN/yYvbNFz6UxN7FCyTHoq0oVfcgRGPvSQznPmg/D0jJMWZzqW5FxZO9Pa+gglrHxjLyE1uEihPGT6aE5JYgCX2MBkQhAxX6CWADMSg/X8b8Rg/9I+6r7fyvKbLFMXte+ES1GpGuDB0foSxlqDQZnbZwEMmZFEk+qaP2UF502WrREnGOtXkUcWC89KUWC5EaXMbA/UsrYxKmu2ujbn8z34O7mOVrjPe5q3mBBY4a+XLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(346002)(396003)(366004)(376002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(6506007)(38100700002)(2906002)(7416002)(15650500001)(83380400001)(6512007)(53546011)(66946007)(66556008)(6486002)(478600001)(66476007)(316002)(4326008)(8676002)(44832011)(41300700001)(8936002)(5660300002)(6916009)(2616005)(26005)(54906003)(31696002)(86362001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDY2Wm9QcnVmYVdUY0paVTN0c1JUcDcxSTR5MXNwSGtqd29IYXZwVU82dGRM?=
 =?utf-8?B?SWoxVStWNFYxc2tsVE1HbHF1ZkV3ei9RQ1dnQnNMQkYxVCtRaVBndjdKdkVl?=
 =?utf-8?B?VWtKcEpBTDlvV0hmcDlpZkFuUjBZeUV3SEhEd1A3cElCbVJ6Y1JSK1pvZmZ3?=
 =?utf-8?B?UnpDclVKZ2VWTU9kVXZJcXcxWXQzU2JtNWExbk8vM1RBQ2VNQk9mL3phTS9I?=
 =?utf-8?B?WmhxMWp3cjIwd2JPRElwOG02TnNXbTk5V2I2WUltN2M2L2c3ZXVOdkUvRjZF?=
 =?utf-8?B?MDZMMThLOGJ4Y1NGeUJqNnpUTmgxcGo3ZHZaaHFxelZHdTlvWGNIMEtkL2JP?=
 =?utf-8?B?a1NHSkdHNkMzemhHVFVXdWhFZzM5dHZmNDY2UnFpRWoyMmtvQVJIMzBrczk3?=
 =?utf-8?B?YlpKU0xpMlRwekFaQkJTRDVISWtZcjI4TEMvRGd2Z0lHWWJVQUFJeDE3UWR6?=
 =?utf-8?B?UFVwbldtS3NsMndsM3hkUkE5UEduTVdVcTJsbUVrYU9WeFc4OTJHeS9UVTBP?=
 =?utf-8?B?ajRRalBHSVRXNU9CU1Q4c1Z3QlE1a0VScGNvR3hwdVZxdGhMRnNaU1IvYjVx?=
 =?utf-8?B?ajkwWjJBKzV2Mkx5TFNTZW9iVHAxdkIxN1VqZjVLOCt0WjZQaXY5eG5Xc0F0?=
 =?utf-8?B?NXpYWTlRdCthMXIzSkpvYVBmK0J1emJDdWR1a0VzNDUyNnljVjlrcGZhZUlY?=
 =?utf-8?B?YTFjK0tORlZCbVNIV1lmdzBWNERJaGl0V2svTTRKdUVaSHN6TitNdmtmbFlW?=
 =?utf-8?B?THBwMDZkOGFkK28zSlhYU2gyQ2ZEdWJPc2hvSWNsdThKZEEraXpmWEhrcTd4?=
 =?utf-8?B?WlF4cTVGQkZ6eG5KaDF4YWxmUUN3ZGF4MEJUdmFmcU5CQjcvWnJqemR5Y3c3?=
 =?utf-8?B?T0JzSEFJNnFnRHVsYzRIM2xsRmR4L25iM1ZhK05TTm8rYVJ3dXpDdlZNeDE1?=
 =?utf-8?B?MTV3SC9YVFU1QUk0b0I1RG00S2ZKSkFDNnFrcXQ1SFIyLzhCeDFBMGlYTEor?=
 =?utf-8?B?Yk1ZbnR3Q0VmMlRuYkZVOTlieUJrQkdzRlVxK3c2SVlZSkNXYTNQNWtRcnh2?=
 =?utf-8?B?bDNscHc5K3Mvd2pqS0NYQjFuQnVaQ1JaaU9vUThUbGMxeUZucVJUNXVzbWY2?=
 =?utf-8?B?eEkzU0p1SGxzNmNtZnowOTltOUplQmNRc01INEJsN2s4QitxRFJNS04vZ1px?=
 =?utf-8?B?QkE1TmtBQ2x5MzhrejV4OVhoNm1KWmNVcUZmMXdjVDVaOVB6Mm5KckVBRXdR?=
 =?utf-8?B?YVE5NzVKNEJ1bng1dFo0c2FYSitRMFM4OWtVNUFZQitXa2Mva3F1WGFZRkxa?=
 =?utf-8?B?UklGa05vMXRLZjQxMXNwbER1b0dHQjVuRUdqZGZmMUFiVGRnT0FNT0gvUHZ1?=
 =?utf-8?B?MVVIQi8xWTFJNWZiRWlqREVLTUF2clRWc1V3bzFRQzJ5VFVGMjlkNXI2SklI?=
 =?utf-8?B?REw3dlllM1lxNm5Odlo3RjFKN2pFWitvVW9iU3Fua20rVEZSSldnUUZ5WnZ2?=
 =?utf-8?B?TWljbXovOGpjMlRBRHczaVJHYjRUa1g5TDl5czR5aXppQkRxekZLWWNwdk9u?=
 =?utf-8?B?OTdOZ2F3dzRCQWo3WWRLVUdRZ0tXQ05uK29CaE01b1pWd2JkS1Y5V1k2eHFn?=
 =?utf-8?B?V2lOZVRiWVUrdkIyT21Kbkt0U3A0eldFQlVKT0gwUFp6UDlFN0kwUnQrazBk?=
 =?utf-8?B?UHhuZzI5MjlIUnhXWFY1eUIwRXZPa0QzQ1ZuNndGd1NZKytXRW0ybWVEd0Rv?=
 =?utf-8?B?dEJxOUh6dGxvWEhuZzkvY1RWUDVDby9oclo4aVVaM24raHpHNjc0MlZQT0F2?=
 =?utf-8?B?d2RQVnl2ZjNVb2NNRFNVOGw1aE41bExMU3BwTFRzaWdXc1JRV0Q4em1NdjNi?=
 =?utf-8?B?bGZYM3pOYWJRaVg5Ynp2R3d5ZktJaVlDU3p0a3BuVys3K00yUFNDZTBsaXVh?=
 =?utf-8?B?QTRWNUhpQmZyRXJPTkJWdjlYbXZ1cXRVSWlIQXhSR1BOTk9zU3V1ZFc4L3Mx?=
 =?utf-8?B?NE1tY1h4VmYySWdKdngvSVVncHMyN2FEWlFpbzBiMGxDNm9QbEJlNUJtT01l?=
 =?utf-8?B?Tm1UWXp3M0pnMEhFSEIxVGlib2crYk1yVWhGdlVwYUlQdWNxeHM5c3QrMzNv?=
 =?utf-8?B?REN5RXhXd1JIZkhDZE83YUFMUm5maUdNNDU3OU1qUVpTc0M3VkpMVUFNU255?=
 =?utf-8?B?VEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?ZElxZkloU3ZlZXUwWklHeVgwTHpMZUw3SUMvQzJlc0EyRi9YSFRrRGRPV3BG?=
 =?utf-8?B?R0s5TTNkblcwNkpOdDJ2ZjRZTEtGMFV3OEdmUW1lZS9pTDhsZUVaZW5zSFo3?=
 =?utf-8?B?Q2FlNlNUNHhKSFpwdlZhelpSR0NzdFJaQ1dLR3Y2a0RLaHBTRlhvZGRueTl4?=
 =?utf-8?B?bmFDdERjSzR0azM5L2pMRzNNcWd3MU5Cc0JJKzM2SzdlbWVDemVnd01PODBM?=
 =?utf-8?B?VXp0a3U5SXNpQkVtUFkyazllb1p5Yy9lcnh6WXArVjd5UXJqYXh2OW5iNHVN?=
 =?utf-8?B?ZHExT21TUHd4SXNIV1BDK3R2b3Y4VzNBemliaFl0WTRldHZMblpQMXh2d2hL?=
 =?utf-8?B?RzZYZ3h5YW9KRytmNHNZSHFuYStwaWtKNXYybDZaVUFLZS9xK3g2bXl6VlpH?=
 =?utf-8?B?d1I5NnVIS0M2ODNBUit3Z21ZMUVDOTVDeHBUWklQc2c4TVUwRWp5ZjViOENL?=
 =?utf-8?B?U0hDNXVtTTJTWFNUTExuWXYyanA3bFlJZE02blNQTS9RTGlWUTRBem5TbjIv?=
 =?utf-8?B?ZWlqTXA4RUhGZDB6TDYyYjAva1dTQmFnSUwrMzRMc3hMbXZScjU2YmdIbk9M?=
 =?utf-8?B?MjcyaXJWQ2wyWU5TYlpJb0FLcExaV3VuaDBTclp0am9uVVRWMWdtNTJZQU5i?=
 =?utf-8?B?Z3VpcWxMamoxWDJOSGtNem1UL05NNHZCNC9TMkRsQUZLOGdBM3dOWnVURVoz?=
 =?utf-8?B?OFdXMVdXUEFpQm02Tm5PaXNPVG5IeEdmRmt1YzJ5MkovOEVndE9uZFRjTHpz?=
 =?utf-8?B?SkFPc1pVSlg5R3ROMVcxYzFXOExtQVF0MzhaMUM3NVJhTEFEVmUwSnQvK1Z2?=
 =?utf-8?B?TEZYSEdTeUovZjVmcUw4bDQxVE5UMHdYWHpJUGxldmo3Tk5rRkpBU0xKaGtU?=
 =?utf-8?B?all6ZW5XcnlmZXVwT0luTzlKcXFMWEFwWjBWVnhTeTd2aGhleGlQMWhUSUpQ?=
 =?utf-8?B?Sjc5byt1eEQxQjZuNjIwd0VYeUpScE5NdTlkeFIzOEllOVFpS2hRWXpPODZ5?=
 =?utf-8?B?Z29tb0hYTHJwWFV3dkl6UTQzOGtZVEd6d0FFT2pMRVVVaVN0bDZmOGpZRUsy?=
 =?utf-8?B?eWNtMHZYUXlGMmc5TW5QL05nK0FRRXBCcHBjQkpnaHF0QUMvUWh0TDNETkh6?=
 =?utf-8?B?OTk0YlQwcHFQQWxzc1dvbXNtS3JxUDdvblBXcTYzK1NydG50ekxHb1JIOGxT?=
 =?utf-8?B?ZGFZdXl5TkV5NTVGdjd1NXVMem1Gb2J4V1NWcFZ0YWlBQXk5TC91UVRyVENJ?=
 =?utf-8?B?b2dXS3lVZVhxMjdHNFhzc09zaWdURWxMWnhSdXdxN3pleloyNnZONHI5UnVS?=
 =?utf-8?Q?InksjmiqqckcK54/LvOTH2D9pgu2/C0e83?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abbfc30-0c65-4465-3d65-08dbc3b57dfb
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 02:07:27.4337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrvoCb4ObAVrag6/XgK3nj/j8PUIrC+CwcHjphRDC5xhs5c9I0GIG/AAV4QWJvGrHVENinBgX/hX7neS8xGQwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5045
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-02_16,2023-10-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310030016
X-Proofpoint-GUID: 7T2gBLzLKH1hPDRI4WIuTYbpVB34SIUS
X-Proofpoint-ORIG-GUID: 7T2gBLzLKH1hPDRI4WIuTYbpVB34SIUS
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 10/2/23 18:49, Sean Christopherson wrote:
> On Mon, Oct 02, 2023, Dongli Zhang wrote:
>>> @@ -12185,6 +12203,10 @@ int kvm_arch_hardware_enable(void)
>>>  	if (ret != 0)
>>>  		return ret;
>>>  
>>> +	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>>> +		kvm_get_time_scale(NSEC_PER_SEC, tsc_khz * 1000LL,
>>> +				   &host_tsc_shift, &host_tsc_to_system_mul);
>>
>> I agree that to use the kvmclock to calculate the ns elapsed when updating the
>> master clock.
>>
>> Would you take the tsc scaling into consideration?
>>
>> While the host_tsc_shift and host_tsc_to_system_mul are pre-computed, how about
>> the VM using different TSC frequency?
> 
> Heh, I'm pretty sure that's completely broken today.  I don't see anything in KVM
> that takes hardware TSC scaling into account.
> 
> This code:
> 
> 	if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
> 		kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
> 				   &vcpu->hv_clock.tsc_shift,
> 				   &vcpu->hv_clock.tsc_to_system_mul);
> 		vcpu->hw_tsc_khz = tgt_tsc_khz;
> 		kvm_xen_update_tsc_info(v);
> 	}
> 
> is recomputing the multipler+shift for the current *physical* CPU, it's not
> related to the guest's TSC in any way.

The below is the code.

line 3175: query freq for current *physical* CPU.

line 3211: scale the freq if scaling is involved.

line 3215: compute the view for guest based on new 'tgt_tsc_khz' after scaling.

3146 static int kvm_guest_time_update(struct kvm_vcpu *v)
3147 {
3148         unsigned long flags, tgt_tsc_khz;
3149         unsigned seq;
... ...
3173         /* Keep irq disabled to prevent changes to the clock */
3174         local_irq_save(flags);
3175         tgt_tsc_khz = get_cpu_tsc_khz();
... ...
3210         if (kvm_caps.has_tsc_control)
3211                 tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
3212                                             v->arch.l1_tsc_scaling_ratio);
3213
3214         if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
3215                 kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,
3216                                    &vcpu->hv_clock.tsc_shift,
3217                                    &vcpu->hv_clock.tsc_to_system_mul);
3218                 vcpu->hw_tsc_khz = tgt_tsc_khz;
3219                 kvm_xen_update_tsc_info(v);
3220         }


Would you please let me know if the above understanding is incorrect?

Thank you very much!

Dongli Zhang

> 
> __get_kvmclock() again shows that quite clearly, there's no scaling for the guest
> TSC anywhere in there.

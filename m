Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479C67B3B1F
	for <lists+kvm@lfdr.de>; Fri, 29 Sep 2023 22:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233304AbjI2UQM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Sep 2023 16:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbjI2UQL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Sep 2023 16:16:11 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EDBB4;
        Fri, 29 Sep 2023 13:16:08 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38TK5P0g014628;
        Fri, 29 Sep 2023 20:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+SYePwEY1X0FtPs8TBbqHFpxn7GVeO18UbhfEvbWcsU=;
 b=Gd3O1HbB4/yyeqB8GNIVjw0wu/+5/dAzWRxPwYZOFhRKjpeDqPXUx1njRrCi/YIfoGVY
 Dug06LgV+yR+bgFxgo+OC6hUO8HhZbpNTWxyXtYoMbNW0CZ4Sso3WFHVGohtcvuvZ0F1
 L5sF/R01vOfbs7eDPFPg4qYb+nYgKL0glaAhgDhpp6KDnachSRAKdy4PtyidJW9tOLZV
 BTHykpmJ/ITO9PbTl/bOhFTR4jQA4r6Ds42rpXqIxLpX2rDlL7MXBDvW/YWofKWDEGsi
 kj0FvoXEqlJO8KHT3ZE3UDyW0V63ZcEX3u4kWjbxdOn/m/n7NIah/RBtBd80kNDeSLgN /Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t9qmuqhyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 20:15:38 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38TK0x6e025405;
        Fri, 29 Sep 2023 20:15:38 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t9pfhtnfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Sep 2023 20:15:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxnfCewZjjl3yOW4eDQq4WjfeUXZ/ZiBXC6VpuUW9eozKDZwc7LzoNLGJZ5laQFi6OPYHSKIp+xF/+CJIHWGC1J/pW3dpEYDRT9eVENRT+CEg7lb9/B+Q7YLmh80cs6iviOdGDRVSYSwbKDhw5qVWZqUaQGAWG3ZdBBlZPzpIHE72QbFtscI+5LCXmRg49bI0eDZ0CIe4uDwV+plRzZKzTk9Dic3c5cZaL9rDE7fu2jJdHbuhY5Hx+VahpED0PZEfqUbpxbsSPmzaigny8r/lA+tUES6LIQqqzXATfxNljPDHOQpt5CBqxyYzcDdi8ji9vYBp7eliFE8g1YF77jp2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+SYePwEY1X0FtPs8TBbqHFpxn7GVeO18UbhfEvbWcsU=;
 b=ZN1Fhyc7R8jO3lrATxbUq6L9wsJjvndyaFpdWaoZYfFOlxLXgBqEEEoe4YNuV7sIFGQLUKo+H5qan9qXiAERcsOZTo7gwAVBGrxyz986y0JJdW41RihOmwrdxLH1jpBz8uGp8q/KknL7+E99rcvf4nstj8u1wRQjHke2GHYewk6gz0IkKDM5FnGuGR+xxvShr5domz17gCIcczJzOUka/Gvvco15rwYz+2YuFK1MDaL5jx/vMBDZ1+VAJHQCVp/w/Lqsm3piCimSZ8rC1eBpvHjvyUvix9MwVvkutdMh8gHOEkhs4YOYBPGjyWaaZVeqN5mXUYpS3IA/OPRupsRvKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+SYePwEY1X0FtPs8TBbqHFpxn7GVeO18UbhfEvbWcsU=;
 b=esp0FaJEyoTEb1EKE84E3xKKIdJI8Aj2z4jSe4hmlrs/v1C6ubXtfA1sUOYGE/2iu5O8Cv2F2vqMh54skKXPa49WHcdgOPVJCViL01PbxzqaItpUnn+VVkqA/zhfF2TDMBN8T1ESGluWw3Mb7CvSQuHec2e+NQNHb1ya5pkzr1g=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by MN6PR10MB7467.namprd10.prod.outlook.com (2603:10b6:208:47f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Fri, 29 Sep
 2023 20:15:35 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6813.027; Fri, 29 Sep 2023
 20:15:34 +0000
Message-ID: <a461bf3f-c17e-9c3f-56aa-726225e8391d@oracle.com>
Date:   Fri, 29 Sep 2023 13:15:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH RFC 1/1] KVM: x86: add param to update master clock
 periodically
To:     Sean Christopherson <seanjc@google.com>
Cc:     Joe Jin <joe.jin@oracle.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
References: <20230926230649.67852-1-dongli.zhang@oracle.com>
 <377d9706-cc10-dfb8-5326-96c83c47338d@oracle.com>
 <36f3dbb1-61d7-e90a-02cf-9f151a1a3d35@oracle.com>
 <ZRWnVDMKNezAzr2m@google.com>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZRWnVDMKNezAzr2m@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0110.namprd03.prod.outlook.com
 (2603:10b6:a03:333::25) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|MN6PR10MB7467:EE_
X-MS-Office365-Filtering-Correlation-Id: e502ee64-60d1-4ecc-8ed1-08dbc128d66d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJtnp1rD+hYjG/Enw09VCpJsWvlfGr/xtNzWy2cWPEdRFX4chs29iPczgndKfUQfu/VbdV7t9UJZet47UZa730jE82cGk+WffQ6LIh22nmJmbCzrahPn9dLiTPJ+szsiNc87MMMk29LuOOUKxQYLrThGnJM8wdf6EC1lMc9Pgw2G0ETOp7czJIJkG6LdJNH5Sc9TtocqwntlgHB+9LULYlJqg/AAhNeaGvfA81pWjgu5Cwq3Vrp8F4XsmRDizYTzbDczZHVETPaNCaeYBPaKNyaGs4rNw5m0lba/b8ZJFAaDgaGKf+fi7hz4OFOaPClNSonjcyEcTX2F3GaCQtGNAqkIw2CXz0kTCbQo5Wbi+/pLLLF1he37tfqqXeQjFIoaohEm1CjllE80AePO3tC2I/e4OhVl2NuwZDm6lcN99BGMhbcTdR3J6dF2OVFuo1TNvjCGEa7irFBXKAHhGvIiUDHIJqfA4Juog7fJVJEWul3FgffBBjcHxg5LDjAegJ1KyYq7xcQFYLOwbSMxsJQkQWL5deuhOyn/k9CLBm/n/ROotW+COZXjvRZzFbNRZ65VlIm7JG9g/eu62ShvIO3IQt27RQNfAkwVmljVBYd63XFnbXpngRYLpeRpnfHPJg7JFG3Zxcuh+/8oGLZujVUGXFeNc/pvTZp+6BuoFN5/hxmKnmYTfkZQDXlvy00WH4O8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(136003)(346002)(396003)(230922051799003)(451199024)(186009)(1800799009)(64100799003)(86362001)(66946007)(66476007)(6916009)(66556008)(38100700002)(2906002)(36756003)(15650500001)(478600001)(44832011)(5660300002)(31696002)(41300700001)(316002)(4326008)(8936002)(8676002)(2616005)(26005)(83380400001)(53546011)(6506007)(6486002)(6512007)(31686004)(95530200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmNNVUg2dE9uODcvT1VtQ2VqYlFQZzRHaUtXbjA3aDlOUXo1RlZnTzdBWmRZ?=
 =?utf-8?B?cy96S3dSS1FSU2F4SVdKRTcrVEtJbk9Qd1FsZ2ZFY0Nrb0dZdDRCckFKTWxV?=
 =?utf-8?B?VzJIcEdYWFBrRHQ1ajNRVE1FYkZQdlMrVHJicE1KaDI1UDB3c3AwdDhITjNh?=
 =?utf-8?B?NDc1T3QyZklmc0Nka2tJSDhaWHlvOTBQaC9STjMrWllQOUtqNXZvR1RDd2FQ?=
 =?utf-8?B?a05LRTJoVWpWNWk3OEZBVXZtU1NqcXEzUEVMNXlqWVdvOWVsN2NwWStBZFo5?=
 =?utf-8?B?SS93UklEaHBzbnZkdmkrcHZMZW4xektXbDB2SEkwQ3Z3MGVCemo4emUzTW5a?=
 =?utf-8?B?RXV6Y0gzbncya2xic0JKZTRzbEdJOFJFU051K2lrNDROYUcxb0VnNFN0SWE5?=
 =?utf-8?B?U3JNRXJ6L0xGNGJpWFlmakR5d09NdU5McEdMeVFOM1dZVkhocEVEbUhKd0ZC?=
 =?utf-8?B?QmRyVTMwM3NFMjY3aEh2QVExZFJ1YW0wd2dTamNSeXlEVW40RjFVNjY0eXYw?=
 =?utf-8?B?QitqR3A1QSswRC9uSU1TYjlidmNkQlk3anV4WVZMT1U1bjlJeXNWV0dQd3Fu?=
 =?utf-8?B?clYyOXM2MXpDdjBUd3pSSGpSRld3QkFwZWNTbkp6b3JBRGpZcmVMV1VJOW9P?=
 =?utf-8?B?dFQ3VVZINk1IbUI1YTN5dmd1VDZ3eWRGS21CcVNGY0dDVmpRTThuS1NhalRF?=
 =?utf-8?B?Z3FJNW9mSHc4OFVyc050aDRkZFRIZm1OTHZrT0U0ZTAyMGpxRTlGcEFoN2Yz?=
 =?utf-8?B?NE5NQThlUjVPUUNRaitOdzdWWld1WExqdmxLSDVaUW4xSG1ZdjZtK01XTGha?=
 =?utf-8?B?ZWRXSlFPR3QySmxBNGxlUnM4SGYzQ0dEYWhjYXUxenRuQXg0ck1SV2pjbi8y?=
 =?utf-8?B?Rm8xSjgyWHhlSE0za01HT0ovbmtlaGwyOFJsOGV4ZVhGaTYwTUlpd0toN0dy?=
 =?utf-8?B?cFFiTGw2KzJEQWlGTHFMOUNxMk9pRnR5TGIxUUVRbEdPS1ZESXJ0ZUJkNXds?=
 =?utf-8?B?YTVzUmxGZFQ5QWcyQVlTQnlQWmdKYmdXNm1PbU9iandmc1ZXUUhDTytRODF1?=
 =?utf-8?B?UnRrbjhsTThTRVhHc21JbHVRTGxYTFd5cURkamVIWU5INy8yMnNNVmFaaHh6?=
 =?utf-8?B?elI0c3IxTTZzaWhXNXFGYjl0K2dXbUdmYzV4d3haRmp6M1JjTTkyYXBJUFRw?=
 =?utf-8?B?cW1TZ291ZThDMVNkUkJsUklONkpWZVV1U1djUmYwVkJhZ0pLZURvWWNYL0Ro?=
 =?utf-8?B?bktMRngrTDRDTnBseDlvRm9WaFpvU2tTNFVJR1RLKzhleGFJNXhrbWNmN2pK?=
 =?utf-8?B?M0h2RVZ3R0pDZGRTWlhwWHhuTjlGOEZxQUhnMzNJdXhCZGVnVXBjNmVQZVZ0?=
 =?utf-8?B?S3YxaDFpQUhMZ2N3bjdrQjdLQzFPYkZMcDdCY1NjUTN1aXk5NElZd0JZaWdS?=
 =?utf-8?B?OUpOTWM0cmxuaG41QXZVbGdLU3FvWWV5YWpkNFJHblFrakhYSHlpRDJ3S1gw?=
 =?utf-8?B?Y1BKYVlSSElhSjFuNS9RV21QSHRpZ2RwdGpXMThsYndPVUErNmFnVkFqU3pn?=
 =?utf-8?B?emxpdTdhMlh2eG9VN3AxMkp5TXkrSmVkUDNTYWFhUjk2b0M2K0ZKQnhRcFBV?=
 =?utf-8?B?M2lNSlkzNnpiZ2ExWnFIZG1qSHJJS2RuUjAvTFloeWV0b3dCZHl1MUsycDgw?=
 =?utf-8?B?S25vWlh4RWZBeFFTMFpSRXAwQWdjcDBvZ1FFampSTW5YVFB0SThKbXNsd295?=
 =?utf-8?B?ZitjRkQ5a3pRNklGME1KRCtXTUZUR0ZhWkFSam53RHh0STF1dHJxU1lOUjNM?=
 =?utf-8?B?MnI0RjBjRjIyRVY5cUJiWTFVVFkrWlozVEl6S3haVE5NUTAzZ0VIUHVKTDhw?=
 =?utf-8?B?dUt2VGs3dFlJUm10YW11TURTMzgxNXJVSC9yUUZ1MzE2dUUvakZteFlXaUsy?=
 =?utf-8?B?Z0tzWlpraklNbzUrcVdjbVhBdFVwK1I4NUxZYnJRVHRPRFB0UzkwejF5UGt4?=
 =?utf-8?B?ZXA4Yk1ud2d6VjdqMnJ6aW04QzZXZlMyRVhwS0hhc2x5UHJ3UzQ2cEttSzhT?=
 =?utf-8?B?dnFYUHZtanphOUNLMjJYQmtQaUlybS8yY2lqOG15ZUh3MjNISWZSRWtlTzNt?=
 =?utf-8?Q?jM3f2S2sfoZ8QPCQI2YgY4Yg+?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?azZ0NGZ2UnN5aFNvaHY5ZEJHakF4Q002R2g2TUtzWDlCRmRXTVIwWVhNSGJw?=
 =?utf-8?B?VDBRWnlWTXIrSlhmQWhwc3U3cTIxMEQvYlZUQXZrcmd2elQwcVYycDB6MlpB?=
 =?utf-8?B?NVFqVjV5WVIxMzRzTkM2dWVFWHBGempkNlRlRnBZUTBESWJ2NUVhbGpvU3dI?=
 =?utf-8?B?NGpVa09VcUhqQTFjRnlMdEdQRW11T0J2WkZiLzUxNDFiSzlQSWhtN250eFk1?=
 =?utf-8?B?WmNwRnA2N2VhL2l2c2FyNUlwYWxFM2V4NkxDSzFVNWllOGNhNklSSHpsV0t1?=
 =?utf-8?B?SWtHdTBMZjA5Z2xVa3FtK0Z5QnlKbUlqVW5QTzB3b0lCMXdNNExXakJobUZw?=
 =?utf-8?B?a2pNcDVmZy9NeWJXK09KQjRTODMzVFFHUWw2c3JwRzhjcDRHSXd5U21MM2Vw?=
 =?utf-8?B?dzhTVWZraUtMdmlxVS9KZGJkTGUwVkZqcUY5RjMzNU04KzkvWFVaWmpXZmVy?=
 =?utf-8?B?aXZqTndWdGZURzZpMTh5S1ZBcjdxMjU0ZWdqSDZtc2piYWFqVjZTNEI1U0lL?=
 =?utf-8?B?MmVuNTZwS2J4K2FBZjV4eHUycVlaa285dkxpYzBGYnRlM3RoaTJ0Y25Jd28r?=
 =?utf-8?B?Ulc4Q3FUT2w0NGh3RzRpWWpaKzRBMVlVdEtONzJQNzZIQk1YRGtOK2ZjUlJn?=
 =?utf-8?B?N2JNOEZaaE5RSE82N1RNSURDT2cwQ21xUTZNRHZYMGZ1NUlheHhrOFFaaHN4?=
 =?utf-8?B?bjR5UVE1T0dQNm1KeDlpRC9ZelNjeUhpM0xscGpuRUUwc1FMUTNYT1V0MU1L?=
 =?utf-8?B?MU1Oa1I0ZEdkZXdWWmVNY29nTHdFSTg4YzFTVGFaUzZtV1IxQTlwQWxUZHpF?=
 =?utf-8?B?Y2FxSWpkOWZ5dkQ5aXpwZ0dUcldxNkdrQnB6K2wxdkNXWW5ta2FHb0RwbnQ2?=
 =?utf-8?B?eW00NjBsOTdkWDB5RjZ3VmNXVXVlRWZ5NmFPektHWndHMzVBRjlTeGJ6V2N5?=
 =?utf-8?B?UFRDdnZNN29pWnZscW5BVEx2Mk1PZHVzZ0huOFZ1R2g2NE9oZ01iekhDajcx?=
 =?utf-8?B?SU14YTZZTEVRbnZIbFlSRFJvMk41Q1RnVURkT1UzZGc3TXA0RHdEOHllVDE4?=
 =?utf-8?B?cW1EQ0hBVGxtd0U3UU1OY3dyQ1ZTZmZ3OTIzNnFOVk9GQml1QkZaeDg1bSt1?=
 =?utf-8?B?MWhGVnpoWVlsNmtTZXNQZnMxNmJmMmZSaW1NREs4OW9YYklGWW50SzRTb0x5?=
 =?utf-8?B?MUR0TUViYWppSVRaSVRLZXN1M2xBT3ZGbnI1T2YyUERJV1JPUk5wNUlRbmNL?=
 =?utf-8?B?MDNVOXF1dGZldVFFYnJHdmYwSGZZajB3T0cxYk1vMFFMUG9qQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e502ee64-60d1-4ecc-8ed1-08dbc128d66d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2023 20:15:34.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E+xpuX2W/bJYcjX/26EMVHFUoQCdcYQCwGvCtirS0eahnUnbxy9KS+P9s01vGqShNFTgUvKi+YSw/SKhnmoRmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7467
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-09-29_19,2023-09-28_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2309290173
X-Proofpoint-GUID: IopdY8qZdD8zoGnp-gBsW4OgO2EW2qrq
X-Proofpoint-ORIG-GUID: IopdY8qZdD8zoGnp-gBsW4OgO2EW2qrq
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 9/28/23 09:18, Sean Christopherson wrote:
> On Tue, Sep 26, 2023, Dongli Zhang wrote:
>> Hi Joe,
>>
>> On 9/26/23 17:29, Joe Jin wrote:
>>> On 9/26/23 4:06 PM, Dongli Zhang wrote:
>>>> This is to minimize the kvmclock drift during CPU hotplug (or when the
>>>> master clock and pvclock_vcpu_time_info are updated).
> 
> Updated by who?

This is about vCPU hotplug, e.g., when we run "device_add
host-x86_64-cpu,id=core4,socket-id=0,core-id=4,thread-id=0" at QEMU side.

When we add a new vCPU to KVM, the
kvm_synchronize_tsc()-->kvm_track_tsc_matching() triggers
KVM_REQ_MASTERCLOCK_UPDATE.

When the new vCPU is onlined for the first time at VM side, the handler of
KVM_REQ_MASTERCLOCK_UPDATE (that is, kvm_update_masterclock()) updates the
master clock (e.g., master_kernel_ns and master_cycle_now, based on the host raw
monotonic).

The kvm_update_masterclock() finally triggers KVM_REQ_CLOCK_UPDATE so that the
master_kernel_ns and the master_cycle_now are propagated to:

- pvclock_vcpu_time_info->system_time
- pvclock_vcpu_time_info->tsc_timestamp

That is ...

- vcpu->hv_clock.system_time
- vcpu->hv_clock.tsc_timestamp

> 
>>>> Since kvmclock and raw monotonic (clocksource_tsc) use different
>>>> equation/mult/shift to convert the tsc to nanosecond, there may be clock
>>>> drift issue during CPU hotplug (when the master clock is updated).
> 
> Based on #4, I assume you mean "vCPU hotplug from the host", but from this and
> the above it's not clear if this means "vCPU hotplug from the host", "pCPU hotplug
> in the host", or "CPU hotplug in the guest".

It is about vCPU hotplug from the host (e.g., QEMU), although the
KVM_REQ_MASTERCLOCK_UPDATE handler (kvm_update_masterclock()) is triggered when
the new vCPU is onlined (usually via udev) at VM side for the first time.

1. QEMU adds new vCPU to KVM VM
2. VM side uses udev or manual echo command to sysfs to online the vCPU

> 
>>>> 1. The guest boots and all vcpus have the same 'pvclock_vcpu_time_info'
>>>> (suppose the master clock is used).
>>>>
>>>> 2. Since the master clock is never updated, the periodic kvmclock_sync_work
>>>> does not update the values in 'pvclock_vcpu_time_info'.
>>>>
>>>> 3. Suppose a very long period has passed (e.g., 30-day).
>>>>
>>>> 4. The user adds another vcpu. Both master clock and
>>>> 'pvclock_vcpu_time_info' are updated, based on the raw monotonic.
> 
> So why can't KVM simply force a KVM_REQ_MASTERCLOCK_UPDATE request when a vCPU
> is added?  I'm missing why this needs a persistent, periodic refresh.

Sorry for making the commit message confusing.

There is always a KVM_REQ_MASTERCLOCK_UPDATE request when a vCPU is added.
However, the problem is: only the vCPU hotplug triggers
KVM_REQ_MASTERCLOCK_UPDATE (suppose without live migration). That is, generally
(e.g., without migration), there will be no master clock update if we do not do
vCPU hot-add during long period of time.

We want more frequent KVM_REQ_MASTERCLOCK_UPDATE.

This is because:

1. The vcpu->hv_clock (kvmclock) is based on its own mult/shift/equation.

2. The raw monotonic (tsc_clocksource) uses different mult/shift/equation.

3. As a result, given the same rdtsc, kvmclock and raw monotonic may return
different results (this is expected because they have different
mult/shift/equation).

4. However, the base in  kvmclock calculation (tsc_timestamp and system_time)
are derived from raw monotonic clock (master clock)


When tsc_timestamp and system_time are updated:

tsc_diff = tsc_timestamp_new - tsc_timestamp_old
system_time_new = system_time_old + (incremental from raw clock source) <--- (1)

However, from kvmclock, it expects:

system_time_new = system_time_old + kvmclock_equation(tsc_diff) <--- (2)


There is diff between (1) and (2). That will be the reason of kvmclock drift
when we add a new vCPU.

Indeed, the drift is between:

(3) incremental from raw clock source (that is, tsc_equation(tsc_diff)), and

(4) kvmclock_equation(tsc_diff)

The less frequent that master clock is updated, the larger the tsc_diff. As a
result, the larger the drift.


We would like to update the master clock more frequently to reduce the tsc_diff.

> 
>>>> @@ -157,6 +157,9 @@ module_param(min_timer_period_us, uint, S_IRUGO | S_IWUSR);
>>>>  static bool __read_mostly kvmclock_periodic_sync = true;
>>>>  module_param(kvmclock_periodic_sync, bool, S_IRUGO);
>>>>  
>>>> +unsigned int __read_mostly masterclock_sync_period;
>>>> +module_param(masterclock_sync_period, uint, 0444);
>>>
>>> Can the mode be 0644 and allow it be changed at runtime?
>>
>> It can be RW.
>>
>> So far I just copy from kvmclock_periodic_sync as most code are from the
>> mechanism of kvmclock_periodic_sync.
>>
>> static bool __read_mostly kvmclock_periodic_sync = true;
>> module_param(kvmclock_periodic_sync, bool, S_IRUGO);
> 
> Unless there's a very good reason for making it writable, I vote to keep it RO
> to simplify the code.

Unless there's a very good reason for making it writable, I vote to keep it RO
to simplify the code.


I will keep it as readable. Thank you very much!

> 
>>>>  /* tsc tolerance in parts per million - default to 1/2 of the NTP threshold */
>>>>  static u32 __read_mostly tsc_tolerance_ppm = 250;
>>>>  module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
>>>> @@ -3298,6 +3301,31 @@ static void kvmclock_sync_fn(struct work_struct *work)
>>>>  					KVMCLOCK_SYNC_PERIOD);
>>>>  }
>>>>  
>>>> +static void masterclock_sync_fn(struct work_struct *work)
>>>> +{
>>>> +	unsigned long i;
>>>> +	struct delayed_work *dwork = to_delayed_work(work);
>>>> +	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
>>>> +					   masterclock_sync_work);
>>>> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
>>>> +	struct kvm_vcpu *vcpu;
>>>> +
>>>> +	if (!masterclock_sync_period)
> 
> This function should never be called if masterclock_sync_period=0.  The param
> is RO and so kvm_arch_vcpu_postcreate() shouldn't create the work in the first
> place.

This function should never be called if masterclock_sync_period=0.  The param
is RO and so kvm_arch_vcpu_postcreate() shouldn't create the work in the first
place.



Thank you very much for pointing out that. I just copied the code from
kvmclock_sync_fn() (although I have noticed that :) )

I think I may need to send a cleanup patch to remove line 3296-3297 from
existing code as well.

> 
>>>> +		return;
>>>> +
>>>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>>>> +		/*
>>>> +		 * It is not required to kick the vcpu because it is not
>>>> +		 * expected to update the master clock immediately.
>>>> +		 */
> 
> This comment needs to explain *why* it's ok for vCPUs to lazily handle the
> masterclock update.  Saying "it is not expected" doesn't help understand who/what
> expects anything, or why.

I will update the comment as:

The objective to update the master clock is to reduce (but not to avoid) the
clock drift when there is long period of time between two master clock updates.
It is not expected to update immediately. It is fine to wait until next vCPU entry.


Please let me know if any clarification is needed. I used the below patch to
help diagnose the drift issue.

@@ -3068,6 +3110,11 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	u64 tsc_timestamp, host_tsc;
 	u8 pvclock_flags;
 	bool use_master_clock;
+	struct pvclock_vcpu_time_info old_hv_clock;
+	u64 tsc_raw, tsc, old_ns, new_ns, diff;
+	bool backward;
+
+	memcpy(&old_hv_clock, &vcpu->hv_clock, sizeof(old_hv_clock));

 	kernel_ns = 0;
 	host_tsc = 0;
@@ -3144,6 +3191,25 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)

 	vcpu->hv_clock.flags = pvclock_flags;

+	tsc_raw = rdtsc();
+	tsc = kvm_read_l1_tsc(v, tsc_raw);
+	old_ns = __pvclock_read_cycles(&old_hv_clock, tsc);
+	new_ns = __pvclock_read_cycles(&vcpu->hv_clock, tsc);
+	if (old_ns > new_ns) {
+		backward = true;
+		diff = old_ns - new_ns;
+	} else {
+		backward = false;
+		diff = new_ns - old_ns;
+	}
+	pr_alert("backward=%d, diff=%llu, old_ns=%llu, new_ns=%llu\n",
+		 backward, diff, old_ns, new_ns);


Thank you very much!

Dongli Zhang

> 
>>>> +		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>>>> +	}
>>>> +
>>>> +	schedule_delayed_work(&ka->masterclock_sync_work,
>>>> +			      masterclock_sync_period * HZ);
>>>> +}

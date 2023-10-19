Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210F17CF8AD
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 14:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345501AbjJSM0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 08:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235294AbjJSM0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 08:26:49 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E81BE;
        Thu, 19 Oct 2023 05:26:47 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39J7NsNu006198;
        Thu, 19 Oct 2023 12:20:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ifueRCxdqQ37xvJQLCxnRe0FxKiTlMP0jW1TXTE9wlM=;
 b=lolvU/6zrJd/emTagireEBRy0XB4meUL14imYVnRqIBTpRDJdUYEgpsaLtLxZpq+k55r
 LkofAvL3pHYZChSsKwBa0+uQaRylRDTbk2MciMNAnbkdbL5CQKY8jQQ7XQJXEHWXt5Bg
 ruKwFy0rjTSx/ffIcSQI9QXEURiEtk7ecrrEFmDZ023MjLbUMlTWaPWNiDt00fRyZ4ag
 BuZWAlvlYGi9UbQ/nBzEqmnVT4EwZ4N2kwcX6/q+HSJOx9Com3d7RBVu0ayGRQOEMC/5
 M1+XohlxQ8cw2HuW2cuK0OirDqId5RR2jCEezdNrV4BVXbuiFFxES0+2r4ssZnfFyiik vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tqk1cjnhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 12:20:43 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39JAxOBQ009794;
        Thu, 19 Oct 2023 12:20:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3trg0qnfc2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Oct 2023 12:20:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kPRHqXQ3nXNKHzzTaQkahWAtN+Ixk61F0L/SkrMYE5WJNE6jZXFwubd9G5c/BDAYckCyg9/nkxvLkS67uUxfRKdRsgraWRWZmcSTw4AkPa8Zc7YsoXcbdN8xsV+UQ5J8AuCl/q7l8nKJfjtRooCRGGfpA2sWEe+giXkYBrP8YjscuKATJSL51LRneFFEOoy9yIdxg+01AEQhsxVYcrJ0LOxkxIBZAerm32FAnXqI2uDCIqZ2ifWIxwFGcfEOvl/a8mhyfpJpo8jvSkIDjQflGwxkbMOY25KgNejQAjtH6GGvFXOCAiPCWK6Doh0VzMPV1zaE8YsUm7oNAW8ewfMCGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifueRCxdqQ37xvJQLCxnRe0FxKiTlMP0jW1TXTE9wlM=;
 b=bw71LoxN/Jw0zehYomIvSd0O+m9GioPkQ8DhX9e+RE3Gfi3hwz47QWDN4Su7eIL60qSmdlle9oEjh/VOaAEOJe44ooQa+3E0yrncfs2c3lQwaHT6QjhwqSXIynIiEW7bnyU/31D1rEu8/MRlMUQ0SQ2sVPwb/E3I94wTw1Z7YkDEfGGGcyAO64WCxQmRtoj32kLL10/06IIjjQaTuffFuf+olZVmJsYH2Y4Rm7jfT9ryUaPCjyqcqptu0xxMUfmK5BOb6S2UqdAdWU8zAb9PvnSwl9miTpb9EV1HB9hGAh2p/M5P/iKc83OwvQpvWRialxrZspcHDdzMvHL+XDj6UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifueRCxdqQ37xvJQLCxnRe0FxKiTlMP0jW1TXTE9wlM=;
 b=ta5FFayDsCouUATjIt1Pd7axwwgTM0s6RMGY3o02fdKLoeiPuE3lQJHcaCR36JI+Fp9b9xSrnbbh+2bUCUhkEqvVQnUonvvARGP7XQH6+uaXx8QjJYKl9NLSPTLD4axfMeVGLGzrj8MaKxNd5Lp0LPsPR56oJ8Atfv9oHdlcWks=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CO1PR10MB4626.namprd10.prod.outlook.com (2603:10b6:303:9f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Thu, 19 Oct
 2023 12:20:40 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::6eeb:88b4:77a0:b2b6]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::6eeb:88b4:77a0:b2b6%6]) with mapi id 15.20.6907.025; Thu, 19 Oct 2023
 12:20:40 +0000
Message-ID: <9827da0a-1d35-79b2-f613-9922a3cba64c@oracle.com>
Date:   Thu, 19 Oct 2023 13:20:28 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v10 38/50] KVM: SEV: Add support for GHCB-based
 termination requests
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, vbabka@suse.cz, kirill@shutemov.name,
        ak@linux.intel.com, tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com,
        pankaj.gupta@amd.com, zhi.a.wang@intel.com,
        Liam Merwick <liam.merwick@oracle.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-39-michael.roth@amd.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20231016132819.1002933-39-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0687.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:37b::13) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|CO1PR10MB4626:EE_
X-MS-Office365-Filtering-Correlation-Id: e4ded994-e843-427f-25eb-08dbd09dced1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yux29CNFxJT7bt/sgTM8y3HEuMDqkqmb6f34bWCfQ4jSIoHGumdfuOtwKwCKZAD5gwpg0/+kHZKrnOPthBfM06GhMwLZNq0qzWUfAGya/SrbVXdHVc7Dyl5iT+W37bLTdT4WV+t9VfT7u1fc6kTY/XTGh9pWhxMhrDXFcwDOoVH52EXXpZfkA3Dsd3kVjgCV2QMwTxWrlzpnrdpHzv5EiZ5K97UNHOjGlE4/Z4ypDFFY0LRVgayfoIOhkOCWH91I1pQ759bIoYCdzrq77NufKmjln73ihvjxe/aPO9mhe5jD8J+c+GeDsmjUFe1po+neHp7thB67TvSAJeEpQq9+/v7Has4u4FUlVD4XKho0hXmK/R6LtuhcPWX9KFKVM/q82mN2ln1XGVdDZgBCZ+FCO7OaywV34JoTvrK2417xFMW2Gg3eSYcjRSYjV0u3JniF9A3x7db4Dn+vjs+vij96EuSFYKwZrSCE2uRAVt1WQLJj3VMb4HZjOTP8/bodhz59OXG9d7oUlx3P/tDbEa6G25ndpqpuwnIFiwDYGLC2grRb+6atB8lQYtAPdgaQzpPri3EASdNrsX72TVLJP8bJjtL/bRn1D4J2l3y5D55G7E+kUxQgNDhIUU3d/L9saZ/ETvUqArbj5UhgihENQztjw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(346002)(396003)(136003)(366004)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(41300700001)(478600001)(31686004)(6506007)(53546011)(2616005)(38100700002)(83380400001)(26005)(6486002)(6512007)(6666004)(107886003)(5660300002)(8936002)(44832011)(66946007)(4326008)(8676002)(316002)(7416002)(66476007)(31696002)(86362001)(66556008)(2906002)(7406005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0F2dVJKKzVKZGFEZjF2UHZkWlpTN3ZZeVdtL1YweUFqcWJrQ0xRSlBQbnZY?=
 =?utf-8?B?TndiSzNKam1FOVdCblFtNTg5cmZRdjhsM0ovTGk4czdQYW0vNXltOWY0Wksv?=
 =?utf-8?B?dmI5clA3OHozaHZSNGZkUkZDNnQ1QXFvd1hKRW4vN2w1Y3htWFpTRG9ORFVs?=
 =?utf-8?B?UUdiaDhvMlBTSEVqTnBHQ1NTbUdyMFFITG1IUzkvT1ppU2pyOVRkeVQ4V1Nm?=
 =?utf-8?B?c0JlZ3A4R1o0RVZNZEl2cU1FZXZGRmpUMG5wQzk2QmN5NzFBRHUyQ3dSN1Fm?=
 =?utf-8?B?NlhJTitIWWZtbW9YU2I4NDYzY0twNFo5OFBmU0RZTnhOWE51WDJ0QTQ1TGx2?=
 =?utf-8?B?RGNheXVZZDVmTFFGY3JkZC9jM0w3eVdHVGFtY3hvRTFsWGxZS2VyQi9BVVhE?=
 =?utf-8?B?enNLTlhGMGtRbGhwbXJPR0N5VG5YdlA1bkJZREJxMkx6cmpNQTdTOWhuTmhR?=
 =?utf-8?B?d1RHeW1taWhvVUwrTTJXNmt2ZTg1eWtiWlpRVWxzZ1RmREpTMFJZQW8xQjVm?=
 =?utf-8?B?TmFwNWxXQ1RrWHhKV2N5YVBWc0FKbi9IanpnKytyNnU4MTkxdVNsYS9wVDlZ?=
 =?utf-8?B?anVmN1JGUzcwc3Iyb0p4dUVPZWNMeUNqeDRHSHNKNUZuUTJhblByVVl3cldL?=
 =?utf-8?B?cUpjMzYyb2tjL0Zodi9mSEdud0w3Y0Jsck9jUjZwMjVtR1hrNVJsQVZ0NHlp?=
 =?utf-8?B?SnY5b1FDMU1HanA2Q3VPVDg5SjJqbmluUGlvZWk1TkQ1ZnU3ZWJiaHU5U0hy?=
 =?utf-8?B?OVpaRWtJMXRmUlV4OUJrdGxZYUlxVkNCQnk5dCtZNFRXUWtncFVybWVROTlJ?=
 =?utf-8?B?eStuekZSN2M2bVZ4a0c4YjdhRTU0TmlKaVluU1ErNXEwcWUzVk5GdUxxdjN2?=
 =?utf-8?B?T0gzaitsNjdVVlBhTEdiaWtScXhUdFpaTGRLUHNSWVpVNnI4aFRSNmtjQjRF?=
 =?utf-8?B?S3RGZi9RVUVaa1luVGlNWW9XN3Qrck5CVkd4U1BpUjBGWGVBMTNHSHNJSlhj?=
 =?utf-8?B?Z1hqcEEwb3k3VnhQaUJxOU1ZWFRKbm5JUGV2NFc4eHRuU0lURG5uSlRYUlh4?=
 =?utf-8?B?Nk5wSjZYQUlqTVpXci9VM1lvUDkyK2lNRTFsby9iaW94c0pIT3FrTlB3bnln?=
 =?utf-8?B?dzY0U2dBK3FGK2Z3cjQ1dHIwMUtpdlJrWFVyYzFESkNwalFkTzNPRXlyOE5s?=
 =?utf-8?B?UUxSZzVUcFJJSTNTMXN4MDNvSHZNcmtWb2h1by90YVA1RXd3SG5HdDdYSmpT?=
 =?utf-8?B?dU5Fb3hCSnRGZ3J2QVc4a3ZjVjQwdlZQQjhwSVIrRUhwYXY1RHJCSmEySHVi?=
 =?utf-8?B?dWM5UmltdTIxamRMYVB5VEpBOUtibjlOa2UwN3l5a1VPb21iQTFKdVFkb0tD?=
 =?utf-8?B?NXVhM0hmWkFNZUU4V09GNDBaekpZWnZka255THlxL0grS3RwWE1xTmZ5WVE3?=
 =?utf-8?B?TmlTaHJHQW9rdEtQWkxJdjd3OVhxYXB0dGJRd3Q0KzUwR0JGT01wN2J4UVZt?=
 =?utf-8?B?UEYrVWdPRkxGNDh4YXlrRDNMMEtrUGM0MDQ1NTFpMllSMDAwemRjU3R6cXZR?=
 =?utf-8?B?dUhnZWV3TytJemFkNkx5cm9sSUl1cHNyZXRyM3ViZ20xY3N1c210WHZIQzJO?=
 =?utf-8?B?ZXl1ampXd21Qb2lQRWF4a3pSa2YwZjJ6OE1pU0xCRXFSdE9xZEwzQVdkU3NW?=
 =?utf-8?B?YitxSWN2Q2Y5RGJ1U2JiK1RTZFppWkxlMU0ybGJYaHpCbGhXdEZkblJUWTR0?=
 =?utf-8?B?NG1zaWtuci9rS2grZjh6dDhBTnBtaUY3SFVwMHBwdDBqVEc2eG5WeFlxWlY1?=
 =?utf-8?B?SGZ6a3VnbXJTaDFvMi9LTUdoc1hLWVZBTGtJWlVjRHZIR3RtWXZCdkVzN1I4?=
 =?utf-8?B?c0hpZWtFK2RYLyt0V1A4VElpL1orSFNhSk9DZW8yb2h6Z2JzKzllaGhUMmlu?=
 =?utf-8?B?bEZkbUs4ZDViZ1VqR1JKVGxQbDIyVDJJY3JpbnVLV0Z1U3JUTmhYckpMUFZM?=
 =?utf-8?B?ZmVVMUQ3ZzFYUk93bnRyWW9aQjFwc3NJV2ladnJqenY2MEU4OFdMNFcxT2Ra?=
 =?utf-8?B?cWhNN3EvQStJbEJUZVR1MFMvVkYvRVdaV1NndlZjMXY3d0NFVlFRNDN0TkRR?=
 =?utf-8?Q?3S7Vafh95WI3EEw/ImIvqV004?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UnhtYzcwYWhub1Vkc3hBMVgrZ1F2Z1QrdWsxY0hLY2Q5aXpreUQ4WGE2Wkd5?=
 =?utf-8?B?TThjMWxIVUZkQlBVMjUxcmxPTGhtb0QrT2huQnRSZTVpSnJWZm1jY1BkZ1k3?=
 =?utf-8?B?R29BQmlWT3ppZXc5Yi9sMnB6NmZHbDh0UGl4cEpVekFXc2RaR3hjV3FsdUE0?=
 =?utf-8?B?eWZzNUkyUU9oL1B3eEFNbWdzdTNwS1FLYm1HSk9RZGozZ25KZHNiMG52MFdk?=
 =?utf-8?B?L2ttVTA1MEdZbVllSVdrc3JyVzFLaHBlQTJGM3dsL0grOHZ6RnVid1NScDIw?=
 =?utf-8?B?R0s2ZURBVEc5VVBLWFIzOE90emVxcWlwQzlSVkZYRCtvcnE5UE9NTjBXM0Nl?=
 =?utf-8?B?b2RtYWlCb2F1a0ZhZStvdEZvKzcvOHBaQWxJcWYvVWtMOTcxL3J4SlJzSVFn?=
 =?utf-8?B?czZIeTBMNWFmdDJvc2ZVeFA4Q1BzNGZkbjkyT3N3dXdEMnp1YjRIRktUMGZm?=
 =?utf-8?B?VEsyMTdmcFJYMy9PaUVsSitXaVgzL0J6cXlXWUFvNG5uV1BJalhVaGJ5NnVu?=
 =?utf-8?B?SmFkQjN4Q0JVWkVZK0tZcEY0ODQ1OWtGd0JxeUZFQlpVWXY4MlRETzRpM1lo?=
 =?utf-8?B?cG1zcHIrQVcwdndkNVJvUVpEMDNBckdQYUhDQVZ5TFFsTUtadnJZMFhYOUNH?=
 =?utf-8?B?NVRsSHFaYmF1dzVwc0FTdldvMkNrK01jZ0VhNDVtcm1aR0NHcUJXNWhrS1dH?=
 =?utf-8?B?ZG04Yy9JOUtmaVhGczRoTUM3dVEvMWZKVjF4QkphNlVibHB2N1czK0JHZUhW?=
 =?utf-8?B?WXJ2SEt0UDRHdUJ4NmVodzdBOE41TmpBUWdMc3hISXhqWVROZFV0NzJMVGpS?=
 =?utf-8?B?dEY1RHA1ejN1VmFxZWpZZmFCUWVEaG5RMmxJZlZ2dlVyOHlQQnJibWtNYVJC?=
 =?utf-8?B?WTRGaEZTNmxPSXdjd0cvdGU3YjZQSGZIT2U0V2NRYjQxKzRzQlNWWFQxRHpY?=
 =?utf-8?B?aVREUGVqazZ3dHBsS0RSSzZyWlIvbnh3WXpRc3V2UERlWHd3SWdVejB5eENH?=
 =?utf-8?B?N3ZoWm9QdGVXbzUxVUxNUFk1UW5hQWR3Y1hmdDhydjdYd3hrUWtTNUNLU0Z0?=
 =?utf-8?B?T0t5NjZPL3NOamJtV08zbFpkZUJteVl5ZUJjYlFlWEprMGJWVWE2V1pncmlJ?=
 =?utf-8?B?RXJMK3E0Nnl6VGMzNWFROUFOclhWdXFlQktDcHpDcVRya1hFUmtjVW41MmpE?=
 =?utf-8?B?dDA1S3FyQ0dQeXNoUkN4NGIzQ1NRNTcvUnJDNDhsUDdMVVN1MER1bEFKNklu?=
 =?utf-8?B?R0NuZ2VPZm1BZzJiUTdmYlNWWEFydGltdUJRMXhrTXpjNUtLOS91aExNU0RY?=
 =?utf-8?B?aDY0NWpoNFVwZ3JKWnhWVkwvVURsbVgvV2VGRG9pR0FmOHFhOGE1cC9nbnJ5?=
 =?utf-8?B?Rm9TejdaVXlZQlpweFlWenhDdVcvMFVyV1FxY1JMYTJFMUwwWEp5N2FaaGJh?=
 =?utf-8?B?MWdGY1BqSC9QUWhqeTN0eXhFbWNkYkg1RU55OHVXVVRLYnQ3TDE5TkZuQnRN?=
 =?utf-8?B?TWd0Q1M1N3NURzhQZWkyMzZWZnZmZGJYVzlMVG5MZnMzcHQ5U1oxSEJuSXQ3?=
 =?utf-8?B?Ti9hMlU4RTV6UGNxdmRlTHFkcEhVaFZaTlhNRjJ6OEZEMFEyaDBpbGR3ZXIy?=
 =?utf-8?B?SDlxYXdyMUtsYzdUL3g3NnczekZSNncycStWb2wrYWlKTkl5SWJXSmdBR0g2?=
 =?utf-8?B?ZW5SWnUrczkzTDZWTmFYOXhpRDY1Nk1JekwzMVR2NUJacy9SUGRUcHJBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4ded994-e843-427f-25eb-08dbd09dced1
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 12:20:40.3311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzbHksgfx9vQIv4AYg40nTBFYB/QiMHpyBIOqKCBWmTJo/RoEAWkC/rIDXj/pRQRzSdckBnK6N58j83O4F6WsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4626
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-19_10,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2309180000
 definitions=main-2310190105
X-Proofpoint-ORIG-GUID: 5CEatttn7cAElEDwacprjwfqfoc6WfGX
X-Proofpoint-GUID: 5CEatttn7cAElEDwacprjwfqfoc6WfGX
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/2023 14:28, Michael Roth wrote:
> GHCB version 2 adds support for a GHCB-based termination request that
> a guest can issue when it reaches an error state and wishes to inform
> the hypervisor that it should be terminated. Implement support for that
> similarly to GHCB MSR-based termination requests that are already
> available to SEV-ES guests via earlier versions of the GHCB protocol.


Maybe add

See 'Termination Request' in the 'Invoking VMGEXIT' section of AMD's 
GHCB spec for more details.

> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>   arch/x86/kvm/svm/sev.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index e547adddacfa..9c38fe796e00 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3094,6 +3094,7 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   	case SVM_VMGEXIT_HV_FEATURES:
>   	case SVM_VMGEXIT_PSC:
> +	case SVM_VMGEXIT_TERM_REQUEST:
>   		break;
>   	default:
>   		reason = GHCB_ERR_INVALID_EVENT;
> @@ -3762,6 +3763,14 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
>   
>   		ret = 1;
>   		break;
> +	case SVM_VMGEXIT_TERM_REQUEST:
> +		pr_info("SEV-ES guess requested termination: reason %#llx info %#llx\n",
> +			control->exit_info_1, control->exit_info_1);

typo: "guess" -> "guest"
It prints exit_info_1 twice - was one of those meant to be exit_info_2?

Otherwise
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> +		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
> +		vcpu->run->system_event.ndata = 1;
> +		vcpu->run->system_event.data[0] = control->ghcb_gpa;
> +		break;
>   	case SVM_VMGEXIT_UNSUPPORTED_EVENT:
>   		vcpu_unimpl(vcpu,
>   			    "vmgexit: unsupported event - exit_info_1=%#llx, exit_info_2=%#llx\n",


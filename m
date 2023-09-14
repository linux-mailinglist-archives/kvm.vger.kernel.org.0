Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 665617A0B40
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbjINRGq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 13:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbjINRGo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 13:06:44 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4841FE5;
        Thu, 14 Sep 2023 10:06:40 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38EEpCTc023418;
        Thu, 14 Sep 2023 17:06:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=b0STcZ0d/yhub7O/DcYhfT4rC31+x14RFhXrf4bGt8Q=;
 b=HeXDybhkKSULmqYkt/YlOxpecJQ9tLTM6q61Xgh9zuiYC4Qz+pJ4QhVBmte6z1po/DRS
 frALJR6+EhJwSoVbjJwseuECfKrz8BWI59VtcOzWNQ3wyCoR8E279tPMhYYHj/kvwQGx
 +XlDGB87a8C5TAp9kMqjkStplMmTVq8W9+uDmjOlGTTTUzqV/mQ0MBQ8RqdegR1tB1jq
 aRD350j3SNt6yZpKkKIoUkF/Le29rn/+VVnrQszYpgeX+SUgIfPjRwl5ELs+dY3xDpwb
 PIG2iT4dwRXGLW6OayMP2e0mDNm886AWQ9PqVCnbJ+fS71+XTdIreZPS3fGE8QmqADx0 kA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t2y7pnwm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 17:06:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38EGCp8W008806;
        Thu, 14 Sep 2023 17:06:04 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f597md1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Sep 2023 17:06:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RT2pog9APUX9zjQT+cbIVCDNzzBZ1Q/kXWRJC1VyLXTMoWtGgYiR/Pq/wLMB7NFL5b0rDvvs/LVWvjFPfuBrPP9yFMIFkq7IGGQ8BJDePO31uPTngm1xNgcczPLWa5hbvUBCQ4KzQi7F708xomSSX2txq8r86DEsoWLC9RbPeXLZioAkvr0GglHSPHpoMK06pL8ogyLNRFFX/LmkGhYxxMqnCIXS8b1LIQQQF8GeW2OHpRfCs/glbJjwdA/WlNMG9aj3G9jq4Qm1tj113uFElyrV09mvYsPicaystAvCEotv7jdAn/awRDdx3Saes0x2bSYKhKYplaikv/3pCVyWBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b0STcZ0d/yhub7O/DcYhfT4rC31+x14RFhXrf4bGt8Q=;
 b=IsOF6UcRMp7QxnRfb9KUAGHJLK4pRiQmvu0Xxk7MTbdzWYag5WOyyPf2hBTa+2EgtJwY0FCDSxs2dhqaGdOiw+MQakFwU/++dQWKnePMpJFwXItnVD3pUwitJ7KJaGnGzPySXg+VjTDzUB3MDSLqTcqhQAmsL3loaVAJ+iIQCJi52ZUnRMkMJ5A2Ok2m4kW3gj7u4EIMqs2+mq6xTQDJX6gXO+eOoFPODTzqdVFP5SKuPCLA3TW65Wu7F/9hZzLMAtuCONu2yes65VVU6cDLtpkCyTLMyZyauqL0xaIQ31jpeX1V46D/Qjd+Zx3D8ppUEnPrzAznS7AOMJzHgy5Fbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b0STcZ0d/yhub7O/DcYhfT4rC31+x14RFhXrf4bGt8Q=;
 b=e6i/qLeLOqGnDmxfhmEJE9OOKCnwGyEXbzLjikt3Bm9El/fcGah1T7IEJTrnDMwmGcvM/eaesqYrteTbGaDYHllmkvou2l+3yLyiwO9ELpMMAi7lf8aCl9Bva5hhMmCSuw5VZxmtDlmZLimqqm3Eb4QYS7r9tXMbv8SfuAhcV90=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB7259.namprd10.prod.outlook.com (2603:10b6:610:12a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 17:06:01 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::7e3d:f3b3:7964:87c3%7]) with mapi id 15.20.6792.020; Thu, 14 Sep 2023
 17:06:01 +0000
Message-ID: <93592292-ab7e-71ac-dd72-74cc76e97c74@oracle.com>
Date:   Thu, 14 Sep 2023 10:05:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH] x86/kvm: Account for fpstate->user_xfeatures changes
To:     Tyler Stachecki <stachecki.tyler@gmail.com>,
        Leonardo Bras <leobras@redhat.com>
Cc:     kvm@vger.kernel.org, seanjc@google.com, pbonzini@redhat.com,
        dgilbert@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, bp@alien8.de,
        Tyler Stachecki <tstachecki@bloomberg.net>,
        stable@vger.kernel.org
References: <20230914010003.358162-1-tstachecki@bloomberg.net>
 <ZQKzKkDEsY1n9dB1@redhat.com> <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
Content-Language: en-US
From:   Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <ZQLOVjLtFnGESG0S@luigi.stachecki.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1P222CA0142.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c2::24) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: 3aa6d7d2-ec1d-41b7-dae6-08dbb544df3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S4C4yPdCKFBOndXT1qEy4VxfiSuaip72MeLKe8GCFBVR0YcWAhV11jXxLq2vWYE1d5KpVRz6ZY3htnRrlCdhf9+fja2mWX1H6pHTU0P49/xLmzDyBCW0kyxwNcZHmgYXvYF4aAcxR0h1PQ+9UmFh23lE1AGkhVKFM93V297LmvhTDDZ7EmAu5EZH+5xGyt7/kPHJbezEZfYab9TBV5VP2Ek8K0niK6mQ6QC20QwBCMO6xG4Sk3gLBpSrSeOYWYETFIqpplwgGQEY7lkT3OlEZoZJi5V8TwZWm/EnI5GOxiJX7+HIlgRAB0LOzv5y2IQ0zZBV3R48eQTM4qPoPCjeajBjpmgQcbqtKM+l9VQxbNM2kaM5q7jQuE6noJJ2onA6RAceJbXinj5gmb8Oq//dkZNMBFii8u9xCavmOnyJSKCSSYXvShONc5KkLooXs6Mnh/hQvstBL1BaY8Ri0fNqDvGRgls7Ctw6zPy/oE947rfHOKM4eCYGjKw4d0S5/P0cCMo9WEp7/XDhnV4o3Q2FAj2V/IHYDdHgLQvyF6bRRwOH+98CmIC+1sqIYBzMqNotbKB5LIUymL3lRZeODLFI+5GcDSvcrtwouv2B+GyX42JYWmyOK9t6md198Yaggg+HQTt+Fwtw3rUQ2CeyQ+8r7Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(136003)(396003)(1800799009)(451199024)(186009)(31686004)(6506007)(6486002)(6666004)(478600001)(53546011)(6512007)(86362001)(31696002)(36756003)(966005)(38100700002)(83380400001)(2906002)(44832011)(2616005)(26005)(4326008)(5660300002)(110136005)(7416002)(8676002)(41300700001)(8936002)(316002)(66946007)(66556008)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkpzeEQ5VW05R052UUQ1T0h2RTZ0UG5ONVZJRThhMjJMZnFmOFVFTjg4MEth?=
 =?utf-8?B?ZU1qSm5JNXFBc3dhdGIwUHMzUURaMnFlTjQ3bWIxUFlCcFpsTytCeE5ISEgv?=
 =?utf-8?B?SWZjbG1rNE1XWE11YVR5ajhjczRVNUQ2djFRMEpiYXcrcHhsTU5zSXg1TmZj?=
 =?utf-8?B?YS94c2pVak45Z0Jvc2pzZlRvRVZCL1d6Uld5dEZ1Ri9RMEVpVTd4YzBRcmdk?=
 =?utf-8?B?QTFTT3NiMWdMd2hWK0FYS042ZUQzbnpkK3JQbCs5Y3J3MGoySEhROUJJNUtP?=
 =?utf-8?B?SGFNSCtreUpBckE3VUpTekJZUXlkZnFoTmJKOHlmOVFFR1BXMmovTWtqOUw0?=
 =?utf-8?B?Y2ZROG5JSGRXWDhPWmYrdzVJZUJNSUdTbGJ2aVlnNjdWcHpwUGxFN01PYkEv?=
 =?utf-8?B?OFA4KzQ1VU1relJBMWREc0l4SUp2NkJPQVBlMXVhVEFHR3hzMng3MGRjaFkr?=
 =?utf-8?B?NWhDdkRPTnRuS1dLMm9mMGNrZlkrVTgwdFRkNk9pTE1QNllpV0l0QmtLekIw?=
 =?utf-8?B?S1Rzb3FDQjBqS0R3b25lWVhqdGM1OHQ3T3R0aFgwa1hmc1plQi80L29TbUpY?=
 =?utf-8?B?ZEdhbTg4MEIwS3FLQXo2dE5jSEJ0TlY1YUFML1NPbjZGdFM5RlRtZ3dQa1Jx?=
 =?utf-8?B?WGgzelJFTytmc3M1bTI0a3BFV2thbDNhcklSd3VpSnF5TDhqMWtjVTJybXp5?=
 =?utf-8?B?bG83ckZtTU9ZTWlZZTU2Q2NTMkIwNEVpUlJZOENOMEpXd0FtSEV2S29pWWRw?=
 =?utf-8?B?bDUyemxHb0hwUTdXdDZpYzVSWTNDOTJhQVZwUlpJRFp3UnNwU0x6K1FKU2d5?=
 =?utf-8?B?WTUwOENZODdobkIvcFQyemgzTHJTTnM4bFlMMVRWS3oyNGx2WDlnUElWelhm?=
 =?utf-8?B?aWdpQWpnZ0JLVXM0YlV5QnFObG8yV1lZTEVSUnVjUVlxSlpzaStEM1R1TkZF?=
 =?utf-8?B?d0huS0YrKzdqOFQrSEVES1BGaWRWUVdDS1NYQ240S0tuNTRQa2tucVBRZytw?=
 =?utf-8?B?YzgrbVNNSzFPdUR3RmNJVW15ckxOUFVLNk1jMUlKeUdNZWlxeWFkVmhaVGpG?=
 =?utf-8?B?UUx6bmV2NjNlT095ZnA0M0pKTmk0ZlpNU0VHWi94RHBGb3E1bko1dzlvaXRr?=
 =?utf-8?B?QWJONG5iWVZydEl6cCs3K2NWVVNySG52cDZ3SGU0aWVJKzZFU2p2MVVnSzFs?=
 =?utf-8?B?QTdDalRkRk5OaG05aE5LV1VYS0lqWGEveGovYURVVGpmRUQ4RXlvNWN4T0sv?=
 =?utf-8?B?UnRGeS9YblFpZC9KOXZIQVRQOUpyTmVxQXg0Q050MEZoVi8xaitrU3QyTmV4?=
 =?utf-8?B?ZFlyQWUyTFhCekg2blRtTzVIb3VqUEQ1MXE0TmRkMEp4cFhHY0pONVorMHFy?=
 =?utf-8?B?eVQ2MjQ3OXpPRGhGUngxNnNYcXA0VDBMc09UN1JLRVNYaEhtWUlsbjBxTTlO?=
 =?utf-8?B?VzJ1RFNQZU0rUW5DZXB4Z0dadjNxSitSSWgvWUZxQ0ljQkZSei9pR2lIZWk1?=
 =?utf-8?B?Q3puVlRGRW1vQUlweXpQRFYxZEpGUm16bmZQQXN2MGJHMEtqZDYwaTB3MWZS?=
 =?utf-8?B?aEFPMlAwOCs2ZDlqSEYzYVB3WWhTUC9XR2xtRjY1WjRxaStMV0xBcHRybmFZ?=
 =?utf-8?B?VzdXK1hydVdnM1VVL3ljOXN6Tk95Z0orUFpHZEdFMHloVkVySkNBWncyWjJE?=
 =?utf-8?B?eW50dWkyYlJiaEcxU041SGNuVy9VSjlEVDdXYU1KTUZ2djk1OUk1ZFhPWm1J?=
 =?utf-8?B?QktpYlUzQldQMlgwYmYwbnlxKzZNZUhZaG5Pd1pkY09sMmNtRnpRR1FBc2sz?=
 =?utf-8?B?QjUwQS9KVDNVZ1lodS9haWpHSHpaOElwbVlRZVltYlFMaW1uenQ0S0JFSG9M?=
 =?utf-8?B?YTVvbjhaeVlkRDZReFJsVkc3OFAyeFlaUzhZMWtnOWI2UHFES0xkNTVOUmVq?=
 =?utf-8?B?ZDBGZStIeGtPWVYyN0tnZ253SjBhMndsOWw0NTQ5Zzh6c0pqaWsrUU1WMTlp?=
 =?utf-8?B?Y08ydTdjanhqcGtLZ2pxOE5pbUxFSzBCd3c5dkk2WlhoUkpZNFJEYXNjdG5G?=
 =?utf-8?B?VmkzbUpHdUtVQ1ZxTnFvMGowK1RyZzNUelpqNUE2RWtDN0FMbFhFbEp2ZDVn?=
 =?utf-8?B?Y3Q2WGtBa2g2V2FnNDFoYVlURzhFeHN4ejJVN2R4WkNpVVExemp1aCt6MDVQ?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UmpDNWZiblhSSHBiMzlSUGNhMitwa2dzQlZEbS9VVlk1SXNMcG1aT09VWEkx?=
 =?utf-8?B?TnFaQmF4ZmZFTDhIek9XUUZxZk56SUp1bGYrRktzbXR6T0xBcCtVRlo3YllS?=
 =?utf-8?B?YzFpV1JUU3lHQnBjOTQzS3h4MmE2dlJySlZub3BVS1V1RWdzZVVJTkZKTmw4?=
 =?utf-8?B?QmYyQUpMT0hiLzhYT0lTWVV4MWZlUHdrdk56RWhicWtTWVNPSXRJWjVOc1Yw?=
 =?utf-8?B?MytCbGRUQmhBQ1g4bVRnQnNDU01VenlMMGNwSzBBbVhBS25ieTVFbDY3Tk5R?=
 =?utf-8?B?UWVXTW1zQ3FoM0dmUXNvS0NIYU5TYWZOT21kREFLVURFN1FaajQ2WXdKUDcz?=
 =?utf-8?B?WXQvUjRWYkRWRmpaK0YyY0dGdUtXaVBmT1ZxZTBuaUhXdUJwUGlrdjNEYi9U?=
 =?utf-8?B?OTViMWkvNEVQSEJmYVBlWUxPODR4bEtPdlZLdWpqd3ZVckREbkdLeU03eVhV?=
 =?utf-8?B?dGdpN1VrYnRqZmFxT1lpbDRuRHk3MlFNQUYvVVlZUTVSeTNJNjVGbFkrb0dF?=
 =?utf-8?B?VGo2aHZaVjZJRElrSDFid0wzaUFJT0VrdHFCU1RJSmNoVEJadUJPWCt2TmY2?=
 =?utf-8?B?Q0tDblhYREFJTW9qVnhnbXQ4SjgvaEZCL0lOU2J2dzFremxoTzEzdUFiRmE3?=
 =?utf-8?B?NW9oZ01uSkxkbFVpY1BNTGFUNlhhcjl2UmM3MktrRHBaaTRDUUxOQkVqaEdU?=
 =?utf-8?B?bWMzVVByZVV3RXZWeVdCaFFLZHIzRGdVUGphc005dlhnYzZ6ZUZSOUxQNnFI?=
 =?utf-8?B?dXBIS3NkZzRyYnB0RVdiSU5iSFV3NEMyeUF6allJazlRd2x6RGdQTy9FeW12?=
 =?utf-8?B?N0dxVHBzdmYrVm5aUVo1UUROQkIxWGRkWFVYOTdnRzZTUFdFRjhEeVFZdnJm?=
 =?utf-8?B?bWlkaVNuOTNnMGpnb0pOQ2VnbFVwZHZibHVWUWh0aEs0MWlRNjloem16bkVZ?=
 =?utf-8?B?YjRZbS9xRGdLRkU4QnFYWCtydWg1S1YxSUlxbitkTlp6SmlGNkVzL3N6ZUFi?=
 =?utf-8?B?VEtLU1pCRmZYRUt6QitGdFpRc3M1RlB2bnlaS3gxckY4U2VGcU4za09UTFNo?=
 =?utf-8?B?TlBtbHM5UDJRK2VoWnFXQVl4cmlpR0ZKN055WkZIWEpoYlFHTUw0RXVyWmEy?=
 =?utf-8?B?TUJKVXNPbU1yQmdjMzExZmtYSlhMcGsweFFyek1zTTJJSVdtSHlaYklWaW84?=
 =?utf-8?B?b2ltRjFpanM4Vll1LzZaaHhESjQ2Mld6cnZJeUlDd2FGd0NIRUtyUFJESUJs?=
 =?utf-8?B?RFBWcEIyaXI5SkZHSk83WGMwVGNidEcwdVJmenRzOEtmZWthRSt4M2d0aWpl?=
 =?utf-8?Q?QDPHTbUsBw3wI=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa6d7d2-ec1d-41b7-dae6-08dbb544df3e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 17:06:01.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HlnJilbqdBAm0xmvqUggeWV2Tmtp/53eiNm6SNUOgkF9EZ7LhkPUYcAAC56rDexykhn7NxblfZhEf+9Qxcv2uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7259
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-14_09,2023-09-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309140148
X-Proofpoint-GUID: PPgy1KNNFANtmvh8iB5ot2QuUavKoa-H
X-Proofpoint-ORIG-GUID: PPgy1KNNFANtmvh8iB5ot2QuUavKoa-H
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/14/23 2:11 AM, Tyler Stachecki wrote:
> On Thu, Sep 14, 2023 at 04:15:54AM -0300, Leonardo Bras wrote:
>> So, IIUC, the xfeatures from the source guest will be different than the 
>> xfeatures of the target (destination) guest. Is that correct?
> 
> Correct.
>  
>> It does not seem right to me. I mean, from the guest viewpoint, some 
>> features will simply vanish during execution, and this could lead to major 
>> issues in the guest.

I fully agree with this.

I think the original commit ad856280ddea ("x86/kvm/fpu: Limit guest
user_xfeatures to supported bits of XCR0") is for the source server, not
destination server.

That is:

1. Without the commit (src and dst), something bad may happen.

2. With the commit on src, issue is fixed.

3. With the commit only dst, it is expected that issue is not fixed.

Therefore, from administrator's perspective, the bugfix should always be applied
no the source server, in order to succeed the migration.


BTW, we may not be able to use commit ad856280ddea in the Fixes tag.

> 
> My assumption is that the guest CPU model should confine access to registers
> that make sense for that (guest) CPU.
> 
> e.g., take a host CPU capable of AVX-512 running a guest CPU model that only
> has AVX-256. If the guest suddenly loses the top 256 bits of %zmm*, it should
> not really be perceivable as %ymm architecturally remains unchanged.
> 
> Though maybe I'm being too rash here? Is there a case where this assumption
> breaks down?
> 
>> The idea here is that if the target (destination) host can't provide those 
>> features for the guest, then migration should fail.
>>
>> I mean, qemu should fail the migration, and that's correct behavior.
>> Is it what is happening?
> 
> Unfortunately, no, it is not... and that is biggest concern right now.
> 
> I do see some discussion between Peter and you on this topic and see that
> there was an RFC to implement such behavior stemming from it, here:
> https://lore.kernel.org/qemu-devel/20220607230645.53950-1-peterx@redhat.com/

I agree that bug is at QEMU side, not KVM side.

It is better to improve at QEMU side.

4508 int kvm_arch_put_registers(CPUState *cpu, int level)
4509 {
4510     X86CPU *x86_cpu = X86_CPU(cpu);
4511     int ret;
... ...
4546     ret = kvm_put_xsave(x86_cpu);
4547     if (ret < 0) {
4548         return ret;
4549     }
... ...--> the rest of kvm_arch_put_registers() won't execute !!!

Thank you very much!

Dongli Zhang

> 
> ... though I do not believe that work ever landed in the tree. Looking at
> qemu's master branch now, the error from kvm_arch_put_registers is just
> discarded in do_kvm_cpu_synchronize_post_init...
> 
> ```
> static void do_kvm_cpu_synchronize_post_init(CPUState *cpu, run_on_cpu_data arg)
> {
>     kvm_arch_put_registers(cpu, KVM_PUT_FULL_STATE);
>     cpu->vcpu_dirty = false;
> }
> ```
> 
> Best,
> Tyler

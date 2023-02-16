Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC846990B4
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 11:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjBPKIx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 05:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBPKIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 05:08:52 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79D693D0A4
        for <kvm@vger.kernel.org>; Thu, 16 Feb 2023 02:08:50 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8FhSD022159;
        Thu, 16 Feb 2023 10:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4uDu7wlcpPIcABXug/QQK9C6elGrS/l++AMeL5WhPMY=;
 b=BJH1XmAHX5WomjUNrB6ww7cH9+RlfWGIvGf7rte3+KyLuTGSpP3cqKHoGyUdxDVDR1IM
 b73JTNSQ+FMUTEpCCJZC91Focl9fLN1M2gtcEk2DChNSN+BSg4JQJpKmCp6Ei5wKfoNq
 nCz8GIaDZRaCX3nry+nTMN4PrtTG/mRLss2yDJ2oqBPYSUJuw7yFwAx3T016vtPxx3qp
 qeqrWYlW1/sXNavpCDSVvQXNr2b4wu/e8dZkFnVzRdpCDv6eZMUsjAYzLIkaafG3hLo0
 ofJ0jna/IQ+X1bMxpC/S8eSzLyzchmAujymsTsf4lW51R63Kbod5U+rjEeGUqzejLWjc 3Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xbarps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 10:08:21 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31G8Vri0013576;
        Thu, 16 Feb 2023 10:08:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f848cu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 10:08:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9Peuu/8yrfWEW3K+4ujbdzTw19Sqwalk07YCCszuCxXzkYtbeibyXU6elAp8IIaCqhJQhs70Z0BuYTZGE+oj9c1tK+QydScDs2zSjepEJv5cjsnafVcXhhzN4V1jxdYllYOsJiCt8KCfSoTCpjHOKWa/B1o2Zi8L0VLfJ102LOhB3+MjKBzQ3REb0VD2o8eHeVBPPil15guCMWvXPLuB6VsadRZ8U4pc7pyChc0gB8ZJ0L+/FIu1gRFlNCv8xm0CUz2wk78aLlEDW3YCGGF2ixbAeXcMcYF8sdsF5tyL9NLjENHfw6dSsp6qo9ZzgziY4a+NJH0opF7LtG07+mnCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4uDu7wlcpPIcABXug/QQK9C6elGrS/l++AMeL5WhPMY=;
 b=QgjOLiN1xVzzG37yBPBVOf26PvK5M0qZz767khHmrKwHvdBSxSV7aNau2NWYxrkZp14l+OrNT+BcKr1hQtMJdXhSiwwPzf5xeYzRjQV4B4v1eRkqkvUQjOkEsPF8wQ2P0OLkwYLiXMvQHzL1MNSOIz4ahAJ1kGPSwf0cz86Ii0b02mJf7OpCHXoC7DVxbABBXLwSjXWU7DLbfbCW/Hy33bCcuZcKNPM/80u/p878M1aXefaHnZwTLWRC1kLsQQ3HO6zPqxceqDHObmFUibPZUbnz9SwPbxn17BrAaPUSg2yzvInNgX0jMX150KMTKI2sQ+AR+30I7WmBffwN2DerUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4uDu7wlcpPIcABXug/QQK9C6elGrS/l++AMeL5WhPMY=;
 b=GFYOC6dyjFOn7Y1Tb3oM1LW/ER3EfPfbILfowFl86x9r9Amw/y8LFhDPERnUabI/3h8iewQ1OGzamkPRtht6cwE6V5V9RKql+PfpSl2JTsqDVS3WZmC44TYQnPqlHlcgmGXxBDUEyhrwSdjc9RSKtofXcQb7zz58i95nxq4Wy8s=
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by DS0PR10MB6948.namprd10.prod.outlook.com (2603:10b6:8:144::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 10:08:18 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9b30:898b:e552:8823%3]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 10:08:18 +0000
Message-ID: <6f5da7c9-cec0-3034-ca58-41115c565df5@oracle.com>
Date:   Thu, 16 Feb 2023 10:08:11 +0000
Subject: Re: [PATCH v1] iommu/amd: Don't block updates to GATag if guest mode
 is already on
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>, Vasant Hegde <vasant.hegde@amd.com>
Cc:     iommu@lists.linux.dev,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        kvm@vger.kernel.org
References: <20230208131938.39898-1-joao.m.martins@oracle.com>
 <Y+3+xtof4tC8koSj@8bytes.org>
From:   Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <Y+3+xtof4tC8koSj@8bytes.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR07CA0014.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::27) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB4835:EE_|DS0PR10MB6948:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fcbe897-67d0-4bd6-d901-08db1005b9e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8oq/nA/WaFC0paM8igrmobT8hxVaGHl3/3jcL7dbnocGcMbD4JFuaGdmXMBXGql90WInnvHnPOPiq/Lbm9eztcH+lcbyNTMlY5dNiiI+MxqM5TCJSId3K7q/FwdRLPnKdgw6P3jkaL12y2Bq4z7r2U/DDxvD4A7rc3Qm1E6OrTUonzMuhu7m0t1DljLmlsxYQO9P6ehJciwgvcY43vCneUitWOv+EY7QeeLLmMyZa+y8yEXwmtcnpUiY09fuu2VAkRuZoB8mSQe3whFR0Un0YZPXE8XTjyFOmWCippYK73KfQIxI56b0xR3tvVOvxce15nuQtwRJBExEPv4Wv6UudzxFhf+a4OzJoE7pXeIBSmFubAMpcatFGdxYNsSENWccXKmTo2LKy/5ojSvutZCXGAfYdvn6/dsvvohz3CWjb1SOxZjTXza9ufwOb4T6RzAYgQOjOqeA5Im0KaMOCDjlhsP8FyW1CPxfU8FF2P98KQ1yYBIikJ2XJ9cbE2wbayML3S+HpO4HJTt8ZrLZymGdn2JgCSASz0BfGCf6wObAJWh/O54fXecNyF7Ij1PWlZ1egkeTmk9L2BHyrgzJFBPN2FFdMyB9ghqSbhndYEdt1RSJi6pEgNDBqhvXFIVJzTIgQW+KdLLjee/waAEdlpEViG5Mo+ZNqaXkKuDC7mLWTk5cbasxZICZrZXz199VxuCmhzYHlDEnBT7V3nNxQmk73Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(346002)(39860400002)(136003)(396003)(451199018)(2616005)(8936002)(83380400001)(41300700001)(6666004)(6512007)(6506007)(38100700002)(36756003)(53546011)(5660300002)(2906002)(15650500001)(316002)(54906003)(86362001)(6486002)(31686004)(186003)(31696002)(110136005)(478600001)(66556008)(66476007)(66946007)(8676002)(4326008)(26005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVRncVMvdUJ4ZHUralN5UmxKTHAydCtlV1BST01iY3M5NkpUR2QwOFhqZmtY?=
 =?utf-8?B?L0pJdW04VHd4Z256SDdVditjWVMyZ0FqMnk0d2VaNGduejg0WnYxQTJlOHNO?=
 =?utf-8?B?VzhiRnRFeVpJSkFuaFVVOUNuTjRpb2xqeXdsVE9EVnc5cXVlVWMzSUpOUHpX?=
 =?utf-8?B?RGhSWklEY01rSERENDh6NDZGaFRtL2V6SWFGZVJ6VDMwWDNxKzQ3dmpEK2Ro?=
 =?utf-8?B?R0JzSXh1VWVmaTBtSm9BL05WQlpZTXVXZGxJSm9EQjhEdzk5b2pJeDk2RkxU?=
 =?utf-8?B?Q3ovNlgrMjhNVzMydklEWCt3MTFzcUFiSjRHVmcveE5TeHF0ZWdhYW5lQmxt?=
 =?utf-8?B?K1c4aUdEMC9iUXl2cUhPOWNLN0pvTDBaSkxQaXQ2QTM5b3FxdVVKSllOd0Vs?=
 =?utf-8?B?U0FVcDB4STQ2VWJTWFh6WGF0TzgydURSc2xKeG1hN1pGdDYxM1NJOHZjNkJD?=
 =?utf-8?B?NG1QZ0s2N2taa2hodDNKNmVET2Y5WURsczRUSUpGbkNpcEtwV3VQR3lYdXR5?=
 =?utf-8?B?Z3ZrcWgrTjlnL0dnWW85dEFUQkZDWTR2bWVQK1k2c1M5SUV6eVJlWXBmQ0py?=
 =?utf-8?B?cHBIZEovYi9ZcEM1eU5meDhZeklNbnZ1ajExZ0o2NmtsL3NVSzBsQmtJMVQy?=
 =?utf-8?B?d1lCM0g2Qk9vTnhsbTd1L3ZvV2sxcDc4RnI5M2xGS3FwSkdhc2g2QU5CUWtw?=
 =?utf-8?B?U0E0VmhiUzIvTEJ6RjFob0ZYVHo5cHdkeVJmc1p1TjgwdERQQTFLcDcvYm80?=
 =?utf-8?B?WmltUFhpTk1kQXFwWE8rRGlPLzZVNHFMbERmZnMwVXBuSkFJNFhpNktac0FU?=
 =?utf-8?B?QWRaMVhIRkxIL09MdVlHOG1WWnhZMnA2aXg5Y0ZKKzV0aXRjQ0ZocGJCR3JX?=
 =?utf-8?B?NGVBS2J5cmFRaTVGYU05RGpjSUpGZ0NFVC9kVGRtT2cyWmNhdml4Wm00NXJp?=
 =?utf-8?B?WVd3d0hpY2RRSUZ4ZjkxVHh1N0NEVFIyK0xDdG13azdRSzF4cjBlZ3QyZTJp?=
 =?utf-8?B?SkdLNy9wWEMyeDJpblg0NVJQTVVpLzZQZGJOUS9NVnNMNnBUS2dSejdEaklK?=
 =?utf-8?B?Vy9FMTBmQzEyL0EzSFlSZGZCMWNwdjMyeU5oSjBWSkRzeGdsUU1RQ24yMG9t?=
 =?utf-8?B?OHFSUEJTT2d5djlteERYcWpvazYyRVVKdnZ0MmQ3MDVXTlhyMU5HQlRZeU9h?=
 =?utf-8?B?eTdXK1ZpWTgrNHRmK3pDbUgwR1dEQUk5enRvS2tvd3M3WVEyNHFabEpTSVk2?=
 =?utf-8?B?a2xXS2IxS2lyNy9abWxadlhLTXR2VDRMdEtka2NTYkRpZFZic0c4Vmo5SHV5?=
 =?utf-8?B?dEE0ZVBaMDRLNHlLMThubVdSOWo4aEFHMFhUdWZtSUNsK2NFVTArQ2cwUy91?=
 =?utf-8?B?ckhVVVRHd3k3MmN3WEdKYmUreko4TzV1cmVqZ2w3eUhrZlVCeGQvc3pwbUI3?=
 =?utf-8?B?MHR6ZW1SaXpqcE1rbUxnWkNZdllkN3NwVjJMMWIyTjVHb2l4SUFwNldqME5a?=
 =?utf-8?B?QXB2NldwTVhGYm1taUpDSm9KaVFXQWMzM0lFTCsxWkhXcTBmNWhvQjlvam5F?=
 =?utf-8?B?TVBpZ3hHbHE3VG9jdlZkamFNUnpybE9mZmFzb05KQkppOHV1OHVmZWQ3R2E3?=
 =?utf-8?B?Z2F4d09iTkV0dDdOUWlqNTg5Nkk0ZmdPK0FKWWR5MGgzVXhnS3R1Z09keFAv?=
 =?utf-8?B?ZTM5dEZrUkhKbTRNMFloaVNTM1lENktOVGxWSTdvdm14MXR0MVVZSjVWandO?=
 =?utf-8?B?S1BhS3dBYVBqZy9LdGlpajlXdVgyeStUK0pYVTNwb0laOUxuMTYzaDJKK3A0?=
 =?utf-8?B?RVgwMmxnNkNwYXB5TitBSG01ZDIyWDcxMXhlMHFsRFgwWmUwcFRUSitXcWIz?=
 =?utf-8?B?Z3oveVVjSENKUWxWbHpEbHZEdlNQdmxJWmtCZjBZV2NKMks0czBFRHNVVVFZ?=
 =?utf-8?B?UXN1NEwxV1FtcCtYSkVZUDYvSXFPYzMzVm1hSnFVSkFtR01hZk91eWpuTnNK?=
 =?utf-8?B?TG5yZzBSaDk0K1RlbGlham9yVUhkclRwV3pCZEhYcTRSQURRekRaT1h6RGdZ?=
 =?utf-8?B?eEd2MzBLbWJ5a3A4OHBwR2tONG51V0NjcDRPOTlKUjBpN2tSdFZxOHNqREcv?=
 =?utf-8?B?R0czeE5KVTAzcko2MGpla3pVdEVDSEthb3YrbzVkZlJueEVIcC9oMkZTZmVS?=
 =?utf-8?B?WHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bGM5bC9BSTUvbVVVMTJ6L2hDM0UrUzhGd2ZRV0VLRkZLM0FBR1J2NGlqeFRO?=
 =?utf-8?B?dTdTQTlWTUFvWDhlQmpBa3JYdHJZZW5xUkxVRTJkbDVzUU1iM00zc0s3Q28y?=
 =?utf-8?B?YkdJNmd2ZTJJVmFlZHd4VW1UZUxIZFU1Y2RtVlRDRU03dzJ1YzhPUDhsQXNK?=
 =?utf-8?B?U1hMSElzRzFHcGo2MjZ1Ulk3WkRvaTd2cUExTDA2MkRJNVBROHlPalRSOGV6?=
 =?utf-8?B?Qk9MbUpVMkRMcmRVS0JVU0Z3TWUrUmo3VFlFVkhQWThLYjNoaUlxN0NiL2pY?=
 =?utf-8?B?bytwWlNGeDJ4RUU1OEtPcmpqTXFFeFBXRlVaaG1IU1Z2REVEaUlhdWxmL0xX?=
 =?utf-8?B?dUplaG9hNklndmtYRDlROTZtekpLLytFUFRjWGZpdUpwbDZzbkFyT1dxcCtT?=
 =?utf-8?B?Sm0xRlh0ak4yUkFpVXNFbnAzaG0wbXJKSmZ1clY5dEh3UHhwR2tvVmhaU2VW?=
 =?utf-8?B?Wk94bDkyaXNUckN3VllIM3RPS05XVUtDbmdOR2h2UVVNZzkxQW5DV2RKMU8r?=
 =?utf-8?B?OXB6Nm1Fd0M0a2xsZWlHdzU1b2xPZnlQVUxCOW9PTGxQKy9lQklEMDVkem1F?=
 =?utf-8?B?eXdhbUtsa084eCsvWHhxK1c0djhWUWJvTDRtZHhnc0htS3pWTi9vZTdPeUJP?=
 =?utf-8?B?aEVjZnJMc0xYNHR3Sm8zUUVPNGMwTzZRSnYrczdTMkRzTGNBWTc4dkF2ZzZV?=
 =?utf-8?B?V244Z0YrWk5HWVBvQzk3bzJ5TFEyem5iZzl4STNZZFRxRW5DU0xyaVNlc24x?=
 =?utf-8?B?SnZMRVFkdVdDaWx2MjhZQXEyaTU2eGgwdlBSaUUwMVp6THFGYTRLbVBZTTZW?=
 =?utf-8?B?REF4OWs1UVFtamZDQUMwRFlVdm5aTG5NYnF5dTg0TE9SV3BpSW9YL1QrbEF4?=
 =?utf-8?B?aGJqc05yV3N4Yi81cEw2M3pEVG4wZjIxQ2xxY2pwZ2I3ais1c0w1cVZRRXpi?=
 =?utf-8?B?MkVqTDVVd2J3QzVDdWJEc3JlSHpYZzJYYlhhYmVwR21mWkQyaUJMYm00NGZt?=
 =?utf-8?B?UkpqRDRKdXJCRUhDVytIVFNTOXVWUFFyMlVmbkVYbnNBMVVqSC9PVGIrUzM2?=
 =?utf-8?B?b1NISkpTU3NCbUZyNVlSWEF6b1JxclB3TGJXSjd0ZllZWkZuSkZmdE5PRUxB?=
 =?utf-8?B?OUsvQ0svaU9Bb1pLL204cVB5ZU1kTExlWVdjSkFMNlJubnN3WkVOK2x2V2gw?=
 =?utf-8?B?c29NMFZ4Nm85am8xekVGT2x3SEFmN3FMTDJYcDI2T05tTjJSeVZtenRUclNQ?=
 =?utf-8?Q?wTy+Zmg17QSsL1w?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcbe897-67d0-4bd6-d901-08db1005b9e2
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 10:08:18.4933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1htp3OyI33DaFJHwCTbwffZkjLBCV3/b6VUG5natCRuefS1WrWGTRnoscQVzGpp2mS+Assg2c1ih/Wp7HYviVvJPJVotuIEgWyuT1xKQL7Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6948
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_07,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160086
X-Proofpoint-ORIG-GUID: x-TBGjkeWtC-p4_f9bMQ1rE7vOHseC7U
X-Proofpoint-GUID: x-TBGjkeWtC-p4_f9bMQ1rE7vOHseC7U
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/02/2023 10:00, Joerg Roedel wrote:
> Missing Signed-off-by.
> 

Not really missing it. It's actually there, right after the 'Fixes' tag.

> Also adding Vasant from AMD for review.
> 

FWIW, I think I have a better version that handles better the bullet (2) further
below. But I'm still testing it.

> On Wed, Feb 08, 2023 at 01:19:38PM +0000, Joao Martins wrote:
>> On KVM GSI routing table updates, specially those where they have vIOMMUs
>> with interrupt remapping enabled (e.g. to boot >255vcpus guests without
>> relying on KVM_FEATURE_MSI_EXT_DEST_ID), a VMM may update the backing VF
>> MSIs with new VCPU affinities.
>>
>> On AMD this translates to calls to amd_ir_set_vcpu_affinity() and
>> eventually to amd_iommu_{de}activate_guest_mode() with a new GATag
>> outlining the VM ID and (new) VCPU ID. On vCPU blocking and unblocking
>> paths it disables AVIC, and rely on GALog to convey the wakeups to any
>> sleeping vCPUs. KVM will store a list of GA-mode IR entries to each
>> running/blocked vCPU. So any vCPU Affinity update to a VF interrupt happen
>> via KVM, and it will change already-configured-guest-mode IRTEs with a new
>> GATag.
>>
>> The issue is that amd_iommu_activate_guest_mode() will essentially only
>> change IRTE fields on transitions from non-guest-mode to guest-mode and
>> otherwise returns *with no changes to IRTE* on already configured
>> guest-mode interrupts. To the guest this means that the VF interrupts
>> remain affined to the first vCPU these were first configured, and guest
>> will be unable to either VF interrupts and receive messages like this from
>> spurious interrupts (e.g. from waking the wrong vCPU in GALog):
>>
>> [  167.759472] __common_interrupt: 3.34 No irq handler for vector
>> [  230.680927] mlx5_core 0000:00:02.0: mlx5_cmd_eq_recover:247:(pid
>> 3122): Recovered 1 EQEs on cmd_eq
>> [  230.681799] mlx5_core 0000:00:02.0:
>> wait_func_handle_exec_timeout:1113:(pid 3122): cmd[0]: CREATE_CQ(0x400)
>> recovered after timeout
>> [  230.683266] __common_interrupt: 3.34 No irq handler for vector
>>
>> Given that amd_ir_set_vcpu_affinity() uses amd_iommu_activate_guest_mode()
>> underneath it essentially means that VCPU affinity changes of IRTEs are
>> nops if it was called once for the IRTE already (on VMENTER). Fix it by
>> dropping the check for guest-mode at amd_iommu_activate_guest_mode().  Same
>> thing is applicable to amd_iommu_deactivate_guest_mode() although, even if
>> the IRTE doesn't change underlying DestID on the host, the VFIO IRQ handler
>> will still be able to poke at the right guest-vCPU.
>>
>> Fixes: b9c6ff94e43a ("iommu/amd: Re-factor guest virtual APIC (de-)activation code")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> ---
>> Some notes in other related flaws as I looked at this:
>>
>> 1) amd_iommu_deactivate_guest_mode() suffers from the same issue as this patch,
>> but it should only matter for the case where you rely on irqbalance-like
>> daemons balancing VFIO IRQs in the hypervisor. Though, it doesn't translate
>> into guest failures, more like performance "misdirection". Happy to fix it, if
>> folks also deem it as a problem.
>>
>> 2) This patch doesn't attempt at changing semantics around what
>> amd_iommu_activate_guest_mode() has been doing for a long time [since v5.4]
>> (i.e. clear the whole IRTE and then changes its fields). As such when
>> updating the IRTEs the interrupts get isRunning and DestId cleared, thus
>> we rely on the GALog to inject IRQs into vCPUs /until/ the vCPUs block
>> and unblock again (which is when they update the IOMMU affinity), or the
>> AVIC gets momentarily disabled. I have patches that improve this part as a
>> follow-up, but I thought that this patch had value on its own onto fixing
>> what has been broken since v5.4 ... and that it could be easily carried
>> to stable trees.
>>
>> ---
>>  drivers/iommu/amd/iommu.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>> index cbeaab55c0db..afe1f35a4dd9 100644
>> --- a/drivers/iommu/amd/iommu.c
>> +++ b/drivers/iommu/amd/iommu.c
>> @@ -3476,7 +3476,7 @@ int amd_iommu_activate_guest_mode(void *data)
>>  	u64 valid;
>>  
>>  	if (!AMD_IOMMU_GUEST_IR_VAPIC(amd_iommu_guest_ir) ||
>> -	    !entry || entry->lo.fields_vapic.guest_mode)
>> +	    !entry)
>>  		return 0;
>>  
>>  	valid = entry->lo.fields_vapic.valid;
>> -- 
>> 2.17.2
>>

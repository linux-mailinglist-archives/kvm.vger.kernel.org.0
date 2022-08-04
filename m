Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9755897F4
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 08:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238980AbiHDG41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 02:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238884AbiHDG4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 02:56:23 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41354F648
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 23:56:21 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2741hxVJ030463;
        Thu, 4 Aug 2022 06:56:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=AU5tsdW8qiCu6kn5KYLGYCJfLF4SbF7lOyQogfW8Yh8=;
 b=Ap9cjwFe0qgTLIds4Lly4X9bwUnlSgDTSwb/1gEG9Iqmuq8R1F++D9oVZfdzkb02/ADD
 LVm75SV+LMZhINlMONHXNjpKEldOCHZl9AScCFPoWq211YK+NigEjUfxhhEWuSvGjTJV
 258kqmkfJouso3G5cOb21NpcpcYg9s5ON+T6/f7ZGEcIfMi7utMLb93ZQFJJQQQnHwDb
 E6HLhYCEdcE+EXVQb/7KYZRgLO11skEnHgUYrzT8EHfqUKfP3SG5TiiI3CuoOp816UoD
 7fJhxrh7QNWxq69aSCWLrRRYk01WvvJnznwIG/yn7L/l5CK9gDW4KkSqEqKiwvnviz0e Zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hmu2cbrnr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 06:56:18 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27465h0g031553;
        Thu, 4 Aug 2022 06:56:18 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2048.outbound.protection.outlook.com [104.47.74.48])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hmu340ynt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Aug 2022 06:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aIptyN3kr9284nVSzgJwt9YoCXZW3mQmBwxjPWEfvqFWHFdoIRl2YLDQQkzk7Tvm3XPABlwtTLhtXp+imQrWOx0SkMUtG/DduJDdYXKN6yLI3wwYC2nsm8TYmenravPc1+45DEXOVIDF0rof2x7Hs131LeM73nXJqu6Sa8iYuvxL1/bpvli0fSn3wm9bmtpVUdQkZWARboVyirqTiTpFIJsJFuehxH09GAhSPpxJU/IT+OR3tCqZThQDTgUOmfn5PWmzTNaYm3N8igEce4w96WxMQCVCZnHjgvyb+vOHQqyBcRQC4KZQ9ss20mWs3BQNWGql58xTFFtCLi3+rWnnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AU5tsdW8qiCu6kn5KYLGYCJfLF4SbF7lOyQogfW8Yh8=;
 b=RyEnwKewq1W7SuU2obUprJmKTYK7TzaWeS/6pXRYOSLq6E7UXD/VNfgIvU+f1iE4FCD2YYx65UZFBJGipruPcL9a4Rpx6lS/F2sSsJgCscsvjGl0vhRqCypzrhfFMsW8PKwTLYcncA4ORyGJltPevg5AxJzC1fih8h0hKOtdGwx/Dp9kX9oyHcHj9gPZH7DkPxJyvFgDhTvcjqRDaT5NYid45w0Do/wI9m4JpOPFFM9yTTQqGhN1BuzEbDw5RsUbunYViBN1oeD2JwkQZgdcchLkkJbCG+ofUblHUuLeUV3AHOx+K4l9t7hHJYdGs0LFoNHAQUvmkMR9KEi7g0/NEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AU5tsdW8qiCu6kn5KYLGYCJfLF4SbF7lOyQogfW8Yh8=;
 b=SyONhpGC+M/Q3b8PlyArUQbpj7nsdNCaN4nGg3SdvrErzC4fQvSMvY8k2s6IcNgl9U6L+NhncGs1AvXGJ0W5TKoGpX043frvnLzyK+gLW1X3BkXWOjod7ed3fvHbwW7t2iyxlIumQg5LBl+TKZTmrFN67MbK54r+gGzo2KUc+5g=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BL0PR10MB2836.namprd10.prod.outlook.com
 (2603:10b6:208:75::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 06:56:16 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::209e:de4d:68ea:c026%3]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 06:56:16 +0000
Date:   Thu, 4 Aug 2022 09:56:05 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     suravee.suthikulpanit@amd.com
Cc:     kvm@vger.kernel.org
Subject: [bug report] KVM: x86: Do not block APIC write for non ICR registers
Message-ID: <YutthQ3aWGGPk/sk@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: ZR0P278CA0104.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::19) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3db4b24-28e6-41ff-5d95-08da75e66d25
X-MS-TrafficTypeDiagnostic: BL0PR10MB2836:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eZugLmNo64S40VOZHrvUaL8stmPcttGgiMnVd83aq33HSxJiJ8BL0lQ7ugWfwDdfXUzFaoWQTGi1qMlhvAYbT91lMfPA/aP5jXO560qDyr/ZfB2+pNYKSm+cgLhCPB3rXGD5KoBXSyRPRSOKyEag6K1xRh1ueGSHJzWeTUs9fuYNpVmtx+pTgYq8xIcCo5IWsIXn95OXxHyr7dqFIxTPOCYzXie3DuPccJRI2cQBRs6cBkMuiZwG84OqD8S9eVTgWFhjPlVAN08ZnaEi/ZE6C7ckoYX+l0fxZbwUyAzevdMzbnnWhcL8eSbRuolYu4YzJHKiKAolVqPgc2gKLE2TJrEGXylpnGG2/tvvZ9QirtNaos3OmNa7K3jsFY5ODn/2T2QgwjO9ebN2apPfGRWwoswsnhJj2SZuNFSX4h04FqGIzUTYhMorY+pPJWs6UkVIF5fFgUJzDhulYB5nFjT37hIsVLI+ZVEhxB5LEzsGT3SQE4kMUTwBNVSQ7SkAqLvkJ4meUTDazyDnTwc3XwXPYDsMVTeVBC4nkI/TMnBEhKKXEY2dwHGq9GmSRYjfTvC8elSbdoKPbgvcqLkRM+yPSR49GrrCAqmsvfT9jZM7TjHT3XQZ5WtL9EyU+75wl++vL6Ztwi9tK1CGYmxfAuwTvl7p+j5HoZp2vHMchDxzf9Gewi8U7okk4ljHi+dtO/c26yZSAbAuSEf6PrvP7z9Ctgr1Adj9PxWMw6YIGX8q9MQmEQW04908PMhbgYRI4y+nUO7QSXxTUWfJd5Uny7jTIjomOyiaTLTaFR8djrX6WJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(366004)(346002)(396003)(136003)(376002)(39860400002)(83380400001)(26005)(6666004)(186003)(41300700001)(5660300002)(2906002)(52116002)(44832011)(6506007)(6512007)(9686003)(38350700002)(86362001)(33716001)(6486002)(478600001)(6916009)(316002)(66476007)(4326008)(38100700002)(66946007)(66556008)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kqKGkZfKI3fKkwQqvHYMXtDzxO4GjsrAHqZF/a4viMRlLZab/99GlPrTBPn3?=
 =?us-ascii?Q?6WOYHxsMNKef866uHg2L+gsopfFlD0ZTZync72NlccTkuU8UBZvFf6s0fcA6?=
 =?us-ascii?Q?KvOjh3lytTZGMr0oLCYevRkvshEh8fySyVvkv/VZcRzLfKnpKTZ1UmBYgVNg?=
 =?us-ascii?Q?EpkAQqcIIAdr813FHcD9R66QEEBz3+PPlevL+zvrbqHCyhsiD3tDjBFqTfmt?=
 =?us-ascii?Q?wGmtWV+PAVMaSny2k5O48/gA+I1Isz4RTyZPfWQoUNrL7TmTLNSJHtqhWVQN?=
 =?us-ascii?Q?/rZCRZVCeyJIkU+KdlbfOaQd8uh4+D0ZuOInHxuF5C500zHKvCLPyfgUCgm5?=
 =?us-ascii?Q?/ApNLpaHKX17jgZv9ZKBl40wRvPkHC6iPOFZUODv77KHsUhzA5h8l5/3cgnZ?=
 =?us-ascii?Q?9oqxRkCWKR2GWqJuu1EL0Cwu9dOVFruqc9hILXoafuPW/2GyuMVvigIz26Rr?=
 =?us-ascii?Q?qALQQ3V/9IC8bijRUQCfTQ/FANKdIRKcfvaiQ5ufJT8RKBDcPoyBguWAKO3A?=
 =?us-ascii?Q?JKagzZbroMxytS7puD7s+9sFlsV0uR9sYW2UvqkXxBKR3hovTcZNfa+DnW/5?=
 =?us-ascii?Q?2NV+7ddDwABEJgahGOalBWbkR9Qn8bbyzbJVx8PHVPfeqKFKi0gIm5iUNbIw?=
 =?us-ascii?Q?x33SH5FbeaK9j5+QTE+c71GL5NSbqLb7LNBSvFzv7BvtLbCKP2y/FvsFmepV?=
 =?us-ascii?Q?fVjARd8gI4U7H3XxV3Kxx+fJ40dVyP3BbCwUqThH+OKw1dCMaxoNWeDQDX7e?=
 =?us-ascii?Q?5uXh2fBWym30MpaSsxEnZlkA+TQFWEW3quB5c13Bzh+fLA5HuOGebhdazBXd?=
 =?us-ascii?Q?MbnFc3KXUJ+xWgBIfijACvGx3eHlJWfVZJQP2CiXTFruhagc1u1JaW//ARBd?=
 =?us-ascii?Q?RojDXe98Z/27BPixEX31boj/HEUgZ4u9DyDaFXhJh7fwUbT2Pg0lF1Vl87uf?=
 =?us-ascii?Q?XIUYJWZHuDvYaBrSpldvzeXv7NesNq4MPP2Dl9O4pTBKkGWRkGoQMmcaiff/?=
 =?us-ascii?Q?1kr+JOvzfOrpK7pU2Lj6SHVOUBsmc0lelYBCXvV5rK2x2npkbpC/RKN+daXX?=
 =?us-ascii?Q?x89PicRFN7LSAcPokBvxdjxMaGVHNVh7aft7YHQt+0SLzIGvdZ69a4YE99lw?=
 =?us-ascii?Q?NP4Jqu/M4HmghWSrk1f4PwvxzKzOBok9Qg/+OjpJsn/m8Bh/wQKLI4rwZTIZ?=
 =?us-ascii?Q?kzKQlNyoPzNDIniigpVWMXc+VnayKIc3wDMNd65JDMsZbG4OHmM4uxOHXwDV?=
 =?us-ascii?Q?bxIxrww3t2LFogR7ArfeGrXvJy5CSIGxU//mRviQaro25o5n4JnOn5oqsgWc?=
 =?us-ascii?Q?oejhUAnwZSYsHjaVxSLcinJW0WOz5T7nLqv8bcLYjo1AGdm8a0WOIougpwt6?=
 =?us-ascii?Q?X6O3Qv2honRcvm1gQtb9qobfY3YXTWy/L7Tq3Np+5u5gGFxY8Og7z64R8mHb?=
 =?us-ascii?Q?jsFGKXydWDMRRrhEWF/M7TNn/Q0QR71KUI+ImVRzaoZ9Ez7/SLGOv17mhQ3z?=
 =?us-ascii?Q?mq7Ipyt9hAhEP3OBnEoiRI95wrmmjUiDmG7WhV2uHzg9wQkXfvaAp4y4ZRzQ?=
 =?us-ascii?Q?rRgg9BEjwKLRqCPlkzmVX0V7C1VSVzANMoGJT1yM?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3db4b24-28e6-41ff-5d95-08da75e66d25
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 06:56:16.5751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zzwgPh4ne1uGh5WpEHSRfot6CpK5laQBR083mchqnYCBfefsjLCO+HkuAyrseJ2DKGmc7dwTnhCLx7ZtOwYMGm2ofjVtv2FxCXH2cbxe8Hg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-04_01,2022-08-02_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=566 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208040028
X-Proofpoint-GUID: FN8yg7wQEOXrN0EzjgwGqJ1SWoFWMRbj
X-Proofpoint-ORIG-GUID: FN8yg7wQEOXrN0EzjgwGqJ1SWoFWMRbj
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Suravee Suthikulpanit,

The patch 1bd9dfec9fd4: "KVM: x86: Do not block APIC write for non
ICR registers" from Jul 25, 2022, leads to the following Smatch
static checker warning:

	arch/x86/kvm/lapic.c:2302 kvm_apic_write_nodecode()
	error: uninitialized symbol 'val'.

arch/x86/kvm/lapic.c
  2282  void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
  2283  {
  2284          struct kvm_lapic *apic = vcpu->arch.apic;
  2285          u64 val;
  2286  
  2287          if (apic_x2apic_mode(apic))
  2288                  kvm_lapic_msr_read(apic, offset, &val);

Originally, this was only called when "offset == APIC_ICR", but the
patch removed that condition.  Now, if kvm_lapic_msr_read() returns 1
then "val" isn't initialized.

  2289          else
  2290                  val = kvm_lapic_get_reg(apic, offset);
  2291  
  2292          /*
  2293           * ICR is a single 64-bit register when x2APIC is enabled.  For legacy
  2294           * xAPIC, ICR writes need to go down the common (slightly slower) path
  2295           * to get the upper half from ICR2.
  2296           */
  2297          if (apic_x2apic_mode(apic) && offset == APIC_ICR) {
  2298                  kvm_apic_send_ipi(apic, (u32)val, (u32)(val >> 32));
  2299                  trace_kvm_apic_write(APIC_ICR, val);
  2300          } else {
  2301                  /* TODO: optimize to just emulate side effect w/o one more write */
  2302                  kvm_lapic_reg_write(apic, offset, (u32)val);

The warning here is for when apic_x2apic_mode() is true but
"offset != APIC_ICR" and kvm_lapic_msr_read() returns 1.

  2303          }
  2304  }

regards,
dan carpenter

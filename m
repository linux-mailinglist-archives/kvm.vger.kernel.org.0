Return-Path: <kvm+bounces-32448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 716659D87EC
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA0E6290CF1
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC13D1B21BA;
	Mon, 25 Nov 2024 14:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fauyKGJb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="rkMRMo7o"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAAF1AF0D1
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544863; cv=fail; b=IKyzo0f5ozXL6aBteKFS5UuzViPWA4+7oVygGA48UY3v2tWinVVw9RyuIsfEjw3dbhwvwpWls4m90nht5ObJ7k/55elQY6FW3vdW1M8KUipuspb1ZZboPrxvSpdFqJb4XNXhBsk93fJlJv4b/TfeFIeuUt2BomfJhDkXeXh2qWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544863; c=relaxed/simple;
	bh=MALxbRLiBHRkRlbyebu6OTMEjurF1rx4AFrofXVYIFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fD6KCxIa2egAsb4acz3S4pgAgS+eHEPk+JVleaBUS9yr8rlFIkGTIw6hIa4oxlSvZjAu7PCb2tixkEqre6uaP3xlcvReDgPWBAjwJfRiCY5cXLRIzd8G+PO7CmaHPIZHcE3ul9M1gi8SVf7mDcsrNadIsO8vmUZaah+dQbiHO2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fauyKGJb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=rkMRMo7o; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fenW003680;
	Mon, 25 Nov 2024 14:27:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ipoV9WK3RuMHwbmP3L6WzHMD/UP1pjywH8C3EFRAAZg=; b=
	fauyKGJblT0cAEtn2DXHf6qvDOt47p/dDPv69WTwz0wP+34ZkLllTnPsbj7i2M8L
	DNkkoWgOGuGPUzCcxzPUzsYfEcurwObpGb+kTbnhSvVU+rTUaRqVUX51n3EwuzVb
	PDxAUyYeQPVcguBVzx2d7Kc4Xzhh0ahGHK0GdkTIOY0e4EAs1OM6cGpp+6bUe+wM
	aQrJDGu9fuESv9cFFm4imGKsMA9KWqooBHt1SrCagn2VxO/n6sQzBrezrpPboo8b
	ePwZoA/dlynxUacF4g+jbmpqJ31mg9lVp+DGopHDQwqjFsGhAPhTWADTcrErRihg
	fSJW5Cy4TngbKTaMvfEC6w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43384e368v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APE8bJ9023429;
	Mon, 25 Nov 2024 14:27:28 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7k1m7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fy2Jg6xU1OF5kxsYug7jr18llSiAwYUTLSBM9GFpghQ0yh6TxM1+DhYNGVN607/ZZjlfgS55DOD6wMVzsCCqeybXQAvn7cuduWMxRxUMYJEDBfLJoo7oFDbPHLo53T1FAbvpEWUkUa6i/CXtKc1LT4xw2yHDr9IY1bKhDxyZy20+7PB5t7YscuF6ZJeJqu/3N3wwOHQJh6zPJhp45xxoFSR0Wase3Ck9KHJmWdCZsS+synvXmtnfYAebYN8uHIjsC3+1Sx63vdDlJPV2CyCayYhtpEGUv3LR9XNf6/EXnolUtSgxH4udVeWW6VfempDhFy9OQ5lv+zr67kwMZyt43A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipoV9WK3RuMHwbmP3L6WzHMD/UP1pjywH8C3EFRAAZg=;
 b=L3lsCMwoPPMzF7ilxH5SCiKQdi0pieTYDtyc79vanCCaY+ZSGX/2IxwqKegglNpgN1VAPE/KojAJGsIgYOM6bXTbyfwLN4zplfWiOo0YoX4x1n5qkpt8c0Mym4FjPpKCc4kmmRWELZxn/1RFZ4VaF4clz8vjtqCeWIwvm+Xl3XXIfPAInQdZ8dZJzg5k5xD93kn+qB1IdGSpvYiGeWoD/aB/mMoHqRLu18Mm35xKTRo1dJNR44ALXbAiuZRrHJ4lFPY1Ctwk80HtFcRuB1NsEHj6rBZ+hwtJVyO61U0l8CirrDTKUVRUROz6b4HWqValsw5MWMH5t3FLXHrkzAgfIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipoV9WK3RuMHwbmP3L6WzHMD/UP1pjywH8C3EFRAAZg=;
 b=rkMRMo7oJToxECtIdsFZ/vjMKBQnih5bW9/6hUBLleU/yw85sWs1ZQU9DxoDTBDFxoXzgn/sCuwiEiIyPbuSRp81Oq7gHDXFI09FS80F7hdFImAqQ3xRs3ij7QkvAgN/ixG7ebqbE6JUmtvXHbAmhL76zlQ4r/dkUdN/zfpy3us=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:25 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:25 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 3/7] accel/kvm: Report the loss of a large memory page
Date: Mon, 25 Nov 2024 14:27:14 +0000
Message-ID: <20241125142718.3373203-4-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:930:11::24) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 09158a3e-eeb3-42f2-d430-08dd0d5d4825
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N3ccyYRSuCwRF25PeLTw2kpettcc5PvjwQFrN8O+8ksg7Kt+RZktP/gHuDod?=
 =?us-ascii?Q?Q0mOm0hZClVMwLRMPNcLnduppexK2G84ejPpVgE097JxCXs3/dw0qPnbhRdh?=
 =?us-ascii?Q?2E2KG7mX+c88eB0kbIKpjwX8YXzZVIYiMy7gZloWuroT9+ypu9rOdK32sbjO?=
 =?us-ascii?Q?RvYP7hsn/M1FpCu5/+gi40Ox+arpY+7bd3DajfnVcnIYSKNgmyBbYHe7pSyE?=
 =?us-ascii?Q?sl8NxzrM8v+5rEGbcEgA3Dsir6lrJBwrMpQsxpG//5OFgR3yHUYFlP6heHah?=
 =?us-ascii?Q?+4r1KrH3vLWdwOFuq4ICLDcq5+pGdVpsQumdUFcV49agB+M2zffK1+9ZTyqt?=
 =?us-ascii?Q?LzKcfBxDjS3mx9DAqolzDiiz5dx2mfQq1JnAlHsWp37VhyjJDG/CKqr7SC8t?=
 =?us-ascii?Q?+4ojPKI4cM8Bi7EEYmuunVu0MAzZeVGrgZ7n8KSp8UVht9bUmiSmdouiC7ZK?=
 =?us-ascii?Q?af2Vs7+6c6qbRc6rayhUaetWfTtTQHMVwC1oZCL1JFDoAYIAuw3MLiVP5CnO?=
 =?us-ascii?Q?EvUt5qobx405e2uUrHjc0Mq7VRN2KZyvM+cWL7VWLtnjX10dRX5rSzsoT3M4?=
 =?us-ascii?Q?omUgdVQOYtVu7x9ybHdN87ROHkHkfAbwGJyBOkpdi+Lv4H6K6DuDmfqV7BeI?=
 =?us-ascii?Q?05SR7KyqdVN2NeGKQwc7ihs2hRpa9u2z8ePtWjwch6oIOf9wfCPeawKJhUhr?=
 =?us-ascii?Q?/oumSMO+I9zr6hlZsnIjnqBuNDA9xbTh5t6o8L6LKGv8WkcgADjWlKQqq8dc?=
 =?us-ascii?Q?3JRGZ93KjcPuQ4MmmC7j9vH1T8cvPFAFHFHTc0+/3knT2xVRQeqg/oQp2rng?=
 =?us-ascii?Q?/WNUFinp7/JwGkjHLqhSnzXbfslAVmJyYIXepuMp8ZxcCfYA3KKFOWfCN0Pj?=
 =?us-ascii?Q?29kgAOkl8FNw8rZtBa7XYPhMdS3ZnlITkGINJh9tn8Oth6OSgxdrIAhAL6jz?=
 =?us-ascii?Q?ZtL7TfFc8CuS3YWZKjdC9qKGqLv4Fx7Zx/+C7dsSWnw3Dp/4WNEfbfmvtYur?=
 =?us-ascii?Q?G24KJ4+pOmNh9l/pDh4mUvREta1fnMkkUGntQ3s1X9uWELiRWLWeQkgJUDo6?=
 =?us-ascii?Q?i5wbyPAX1vYrFsGBC82/gRpDdmUr/+nrujhFARUhZHflV76LGeYyZOiP2rhX?=
 =?us-ascii?Q?xKhrC10PEJ6qPENazUxi4Q2wEdRXJovfNBqpS0sM8NvZsoTfaCNc7NPT+Gri?=
 =?us-ascii?Q?TN+xTTH1vMY4V3VzVrvCtWE0DVXgKEQd6US6kqMrjUzKmLJLLLCC9C1sg3MJ?=
 =?us-ascii?Q?UkwZIQxxreXzNJHvLhdReSiduq3OeJ3Ov4ydA+ClS0SrkbCdpFcZwcmKnvsf?=
 =?us-ascii?Q?qQwRhodxLgEK60jKzd9jY0daU0/oma1nqa2u8LgsWIGVeQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IEEf+eIyqWCIPjTsLIY+vwdA5a3+KKQK4FUTKygOs4hvmJpxFYiqmRlIRFDX?=
 =?us-ascii?Q?Yy9ZMLeSP8PEtbCYDsFUnpeECsZihdm2IKgp2GV8I/OsNEn4GmoVTe4mdc5U?=
 =?us-ascii?Q?h3D/63aQDikSDZ/dnlKQedEuMgpgp67Wk9kKG3l5RWrUugYgl4Gbg1CyOxAZ?=
 =?us-ascii?Q?2ASebS6YzqKhIRkjn9T1Qp27THV36ZNtkiEjldx8BBJb1xTfZDlCHJ/pvchw?=
 =?us-ascii?Q?gdpG2wLYKcAPbxKEgMW5owEjvVSHAAvSUdJtRaLro0E9Ue9vDJ6yVnwH5Cjg?=
 =?us-ascii?Q?fmLhAkWNBCsAijiQNQNvBUzbY+vsY3HtTaTCcNrvhNk0uUM3kr22HsYclc+I?=
 =?us-ascii?Q?grz5ytecs9uEVyOC2v8vGin2KXlqXrAzB/OpKZ+MFYIkMhuAVnkKynt58pjO?=
 =?us-ascii?Q?xSeTGDNQrMdokkhoHI3pST7vVApHlM3Prh145hl/IO3cKzv9f+ZALbokZnM4?=
 =?us-ascii?Q?x5bcGQzKJnb3y4LINmoeWLE4wbCczMQqNJWwjcAO7+hMo+KTC3miamKxs70A?=
 =?us-ascii?Q?Uskzy4irX/2M2iZNq8hIfjrLu960nom+aoyqGgJNW5W7ZXPo8znFko0AvRr6?=
 =?us-ascii?Q?O3KlztwHxCvCjdLTYUQfhjR4wCE9wEhIz36uYPGmbrBAv/QHpzE4wtVYIQsN?=
 =?us-ascii?Q?5oXGOrHJwBLxLXgJBKrNhRanhBQ4MVn7UXuamcydGXHEm52IF7YDnSMpaGTR?=
 =?us-ascii?Q?XYJIaCeLPFIRt+j0kO2Ej9f+SK9gAv79MN0yUhG1exkLC25IkFVI6kSL48oG?=
 =?us-ascii?Q?QfKfPdEKCNxRz7/v6GUSJ0YvklBduty8xxopqgmDB0/oBp9CD65n3musiXEe?=
 =?us-ascii?Q?o4Qaxlw7U7nXHHwjYtZDevdng3qwOHqwpN3qT2KA60Zqj5qewtPBMVw1RT2I?=
 =?us-ascii?Q?m3/UWo/WG5C4UIhCBupyykwKv6YUs+eOdX0swbW5m5om2RsqIWGpOq72VZ+5?=
 =?us-ascii?Q?Fi5Sm7+tkrgljGDPvrbaJVrlsEFRWhY6K1doJNa/6l6CsqTwwoaooGEudlkM?=
 =?us-ascii?Q?UQkZiKRfy3H1O9jdVipxYucxwfPlLj+ZBM0xFe+QkTassNrAFqR45X6xx6WY?=
 =?us-ascii?Q?odz95fmW5DTh1rieYyW0CIBNrgc8gnJWzQ6A4k6wHeYt03Ry9dss/SUACvDR?=
 =?us-ascii?Q?7r5mrVK6hrR8yRTEFtuZaML0ZFiNJR1oKu+hO87F/SYmGuhO9/j7/v5vSKr8?=
 =?us-ascii?Q?ckECF/ibxTsDLZMdrO29z1kDKxSLUICx/WeJDPCP3pGLLv48tkdTvbwMkwXF?=
 =?us-ascii?Q?2VSUk6H3wBle7blKOPEZxgsxK7V0VLerNLerztmRAc44JgB0x/yRsLe9WA8R?=
 =?us-ascii?Q?PNkL5BF8fOsbUHTMbTc/HgUNUdd8j5/NrXYbT7dV4aeNd8mC6obOxj/ErA4q?=
 =?us-ascii?Q?qVFXQvzVy6/0myiTZ1Da+5JKud/i3GWXzHrJuiFz99P1DpHr5ENOxbhq61IK?=
 =?us-ascii?Q?qslpzUMb35dDaVVN0sE8yMUdvTVv9tIjZma/gYaOku8RjZ8u3Nsk01kpQPAR?=
 =?us-ascii?Q?+qEAqchkXpCtL21mDAce/4Ih4yaiv7JZO0eH5Asi5zWSVombdNKljUukop3x?=
 =?us-ascii?Q?TuT/p1SFdBGqecbfVSq5VgoHFylGu9exhjhyuxFRTSXfKeDGQhvgy5LLsbvn?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fuwZkTX5lOvtwRsGCi25enIodIDOHqKs57hy3Yi53BwYILOaOn98SEbPSWFOwsd/OMzcDY4WEgCFWtRz75eDnMET8brUtNW0uLEOD9I5FkQ8bSt9M18WBN26n7msD6XSHMW26SfnZyuKL2b9yXalFCn7sTzGfoLSFAmYhjC/rts6kKpmPoJTfc2mz/vPwoEGgZlAkb1ssCM1Jr0NW7dSGi/xUc03Ti3X/lscY7K5CReggh/dt/509wVMm8jLfhozZ4mLGZ3VF4RGFZ8v7WtJ5oXNDnGVGrScS7/bcjcwSxyKrA7na9sec9OemhI/EhQqKui6S+y5RWovOzNT04DMCs0PgOwzsEf/jE01n0xdiYYF1mR2am4YM0Qbcxa6/yTDucLRUfUA63PM039rItEhX5nKmTuq7IXDATefRqXTiWbVOFMMSsD1DKhUEL9Qel+W7kQkiUvDULPBzwTAeJhhRsk2H6q8k3WBMPuiW3w+RqoMAlflWRxdlwFiNr7871aLFOsn9gvUDOro/mJkQG+YnuOkrBwMi0KCaQJRPtVeh5IimsWnzQR7mEvW0mxlWWxLqAK5unlOQ1K3pY0q4xQX47MJE1N9srI7fZVgBHSlhQ0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09158a3e-eeb3-42f2-d430-08dd0d5d4825
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:25.1748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kcaD+8bJDOtJaxPSxxibVm41FAG1o6jP3RvgYz/FQ4npudnjs64MzdU2UfuW+yOrZBhZAR/tvY96SdTL3jyaUDNoFXM/ZxMqNEW9HZ/TSrA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250122
X-Proofpoint-GUID: D3RVCD7RyKYiFgbIy4BPasAQVK2MNHm8
X-Proofpoint-ORIG-GUID: D3RVCD7RyKYiFgbIy4BPasAQVK2MNHm8

From: William Roche <william.roche@oracle.com>

In case of a large page impacted by a memory error, complete
the existing Qemu error message to indicate that the error is
injected in the VM. Also include a simlar message to the ARM
platform.
Only in the case of a large page impacted, we now report:
...Memory Error at QEMU addr X and GUEST addr Y on lost large page SIZE@ADDR of type...

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c   |  4 ----
 system/physmem.c      | 12 ++++++------
 target/arm/kvm.c      | 13 +++++++++++++
 target/i386/kvm/kvm.c | 18 ++++++++++++++----
 4 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 24c0c4ce3f..8a47aa7258 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1286,10 +1286,6 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
-    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
-
-    if (page_size > TARGET_PAGE_SIZE)
-        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/system/physmem.c b/system/physmem.c
index 26711df2d2..b8daf42d20 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2201,7 +2201,7 @@ static void qemu_ram_remap_mmap(RAMBlock *block, void* vaddr, size_t size,
     }
     if (area != vaddr) {
         error_report("Could not remap addr: " RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                     size, addr);
+                     size, block->offset + offset);
         exit(1);
     }
 }
@@ -2227,7 +2227,7 @@ void qemu_ram_remap(ram_addr_t addr)
                 abort();
             } else {
                 if (ram_block_discard_range(block, offset + block->fd_offset,
-                                            length) != 0) {
+                                            page_size) != 0) {
                     /*
                      * Fold back to using mmap(), but it cannot zap pagecache
                      * pages, only anonymous pages. As soon as we might have
@@ -2236,15 +2236,15 @@ void qemu_ram_remap(ram_addr_t addr)
                      * We don't take the risk of using mmap and fail now.
                      */
                     if (block->fd >= 0 && (qemu_ram_is_shared(block) ||
-                        (length > TARGET_PAGE_SIZE))) {
+                        (page_size > TARGET_PAGE_SIZE))) {
                         error_report("Memory poison recovery failure addr: "
                                      RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                     length, addr);
+                                     page_size, addr);
                         exit(1);
                     }
                     qemu_ram_remap_mmap(block, vaddr, page_size, offset);
-                    memory_try_enable_merging(vaddr, size);
-                    qemu_ram_setup_dump(vaddr, size);
+                    memory_try_enable_merging(vaddr, page_size);
+                    qemu_ram_setup_dump(vaddr, page_size);
                 }
             }
 
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 7b6812c0de..d92b195851 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2366,6 +2366,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
 {
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t page_size;
+    char lp_msg[57];
 
     assert(code == BUS_MCEERR_AR || code == BUS_MCEERR_AO);
 
@@ -2373,6 +2375,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            page_size = qemu_ram_pagesize_from_addr(ram_addr);
+            if (page_size > TARGET_PAGE_SIZE) {
+                ram_addr = ROUND_DOWN(ram_addr, page_size);
+                sprintf(lp_msg, " on lost large page "
+                    RAM_ADDR_FMT "@" RAM_ADDR_FMT "", page_size, ram_addr);
+            } else {
+                lp_msg[0] = '\0';
+            }
             kvm_hwpoison_page_add(ram_addr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
@@ -2389,6 +2399,9 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
                 kvm_cpu_synchronize_state(c);
                 if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
+                    error_report("Guest Memory Error at QEMU addr %p and "
+                        "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                        addr, paddr, lp_msg, "BUS_MCEERR_AR");
                 } else {
                     error_report("failed to record the error");
                     abort();
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 8e17942c3b..182985b159 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -741,6 +741,8 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
     CPUX86State *env = &cpu->env;
     ram_addr_t ram_addr;
     hwaddr paddr;
+    size_t page_size;
+    char lp_msg[57];
 
     /* If we get an action required MCE, it has been injected by KVM
      * while the VM was running.  An action optional MCE instead should
@@ -753,6 +755,14 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
         ram_addr = qemu_ram_addr_from_host(addr);
         if (ram_addr != RAM_ADDR_INVALID &&
             kvm_physical_memory_addr_from_host(c->kvm_state, addr, &paddr)) {
+            page_size = qemu_ram_pagesize_from_addr(ram_addr);
+            if (page_size > TARGET_PAGE_SIZE) {
+                ram_addr = ROUND_DOWN(ram_addr, page_size);
+                sprintf(lp_msg, " on lost large page "
+                        RAM_ADDR_FMT "@" RAM_ADDR_FMT "", page_size, ram_addr);
+            } else {
+                lp_msg[0] = '\0';
+            }
             kvm_hwpoison_page_add(ram_addr);
             kvm_mce_inject(cpu, paddr, code);
 
@@ -763,12 +773,12 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 error_report("Guest MCE Memory Error at QEMU addr %p and "
-                    "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
-                    addr, paddr, "BUS_MCEERR_AR");
+                    "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                    addr, paddr, lp_msg, "BUS_MCEERR_AR");
             } else {
                  warn_report("Guest MCE Memory Error at QEMU addr %p and "
-                     "GUEST addr 0x%" HWADDR_PRIx " of type %s injected",
-                     addr, paddr, "BUS_MCEERR_AO");
+                     "GUEST addr 0x%" HWADDR_PRIx "%s of type %s injected",
+                     addr, paddr, lp_msg, "BUS_MCEERR_AO");
             }
 
             return;
-- 
2.43.5



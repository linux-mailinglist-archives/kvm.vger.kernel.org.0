Return-Path: <kvm+bounces-11372-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AB64487680D
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 17:07:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 10DB6B21C34
	for <lists+kvm@lfdr.de>; Fri,  8 Mar 2024 16:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDE42C6A4;
	Fri,  8 Mar 2024 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dfFNaB4V";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ov0+spH9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA922C18F;
	Fri,  8 Mar 2024 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709914037; cv=fail; b=hBSsUQ4fwAy4RjsKLFi5iDJFabxxuZI0dr/A1fUWqUjxAfD9rOnuppRN5ZTjxv8YYn9ve58knhR4MyuXeiO37FuaJLXKxH/AE0a3xKFzdNpZPtvKoa1aLJvwOZ7nJCDJtcx3Irx7gp/auoBsFSBC2GdfvB2tAJaBWlB9n/BvTtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709914037; c=relaxed/simple;
	bh=awGD2Fpn+/41TPS9EBzbP8XXAgMJfppjKUxyzs6Rk0o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AvDH+pWpXw8DqJf0PmQBm1y3QgOo01xTt4YNCwjLMzXYdKo0n0ZXoi3az8RAvU+KLgPls64gxOsW+BD/aDaaJlq47raZCEXiWpAZ64rknJtA/tdbpzKzDR65vcHifPwZU7n7itTmZFhBnK1LX9IiAqob/Zhx9xtjuNC7bLsOFbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dfFNaB4V; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ov0+spH9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 428DT6KO001852;
	Fri, 8 Mar 2024 16:07:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=IffxaDGNYEMZfTQEiVmMP2OLPO+2i23JKoPs7IHM9CM=;
 b=dfFNaB4V234l9Rdddt9pWD3yVpM+HtqGpgscSwCg+TjtA+KCVDdtq73MOeHIkf1HfXM7
 7QhHkvt6OHf6u3iJeCVolhUEBRl5dTJkfg1AIjY2FOh5FPkbOTAfBZ/3t1NRlMzAtzFe
 /6kbVxyB54lKb7DJ8fJWMxKfRGDxhd3UZ4by/4hVvAmbNwwZUsbcYHDM841hs7TOaXZx
 4RaoIsXJYd1Ai3v2B1VorfYIGY2UnVQD0q/45u2LjzvCpiFkdGaKZ9qXypqcoOsFp9xH
 BsKWny6o31zXRoP8IdvhkOnUosPV3zgHH5274SOblTSjMa/MBcnTHSf9x9FjSyjM+bfc 3w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wktheq3qy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 16:07:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 428F99Tq005191;
	Fri, 8 Mar 2024 16:07:06 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wp7nvj2yq-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Mar 2024 16:07:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAFAvi+5Umpg8oo27G8hTd00cdVbXdYNGD337jWv+y70ua/jO1OwitXFgUl/kuhjzIRI0tv0nGWmF+fxu68ElWAW1pG6mFfmrkZH6Ej0KyKe7z8IDBjYxyysX3XmZeKTdGFXd89UzPISNvqEnT7jkkENja2G/rjOzOPu8+jDQfv0prja5myVofWHVD8qQKKUmVs9tInJqUzL87l+o/XQn6JrXWCtHYr0a5/8P9gRGysTwUDGNxE5HUgYfnHHxXGF/c4Dr0RwOgMfnDAcO3LwcTrfE02pQ6Eqi9fTJUJ/AK55Qv0zrjOY//w8af1fJB5vi3J31Ulv68fdLR/rd1xzDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IffxaDGNYEMZfTQEiVmMP2OLPO+2i23JKoPs7IHM9CM=;
 b=KlQl/ZBQUztStI7lAx4b/W0/zOv9SAr19olzBTEd12qgLJVJvgg/5WV9XOgeFZtab19xNyMIVW0BVctYo5JItZz2uSoM1Tn417LKWacmyjahUeGxyQP3a+rkw9+9mUyfxIHu21EilUZQYnIQUZgjPqNf5kpS52kXEFW2QamVg2uLZ19x2ga1sfIOlLDROR5VwzBJkgsVwUJNkuGJ+3qFViDE3xQgj6XKx4/u+IJLUriL5CX3fUpW4Q5OH6Szp/aJvt8ZWW9rME2fNA/oa5tnFjqlobEnxUggCEoyeQGg95uT5uqZQet5hsJLAEC1EseoeUtHsStpJsVS/W9Yr5TgYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IffxaDGNYEMZfTQEiVmMP2OLPO+2i23JKoPs7IHM9CM=;
 b=ov0+spH9Hjzhf/VeDcIJ/Lp1OWEta6Pbye6fjtnnMzJ9I+p68ORqpBz3kQ9evB/riXB5OUoNHhnjQbpu85R3FkaD25epLTNaPp0K/FU7lbBf0kRF772QQdnapngtsdapsAQkzGYP/8/az2/FUHeaGqA0JUC2iI25rfvRo2aE2eU=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CYXPR10MB7974.namprd10.prod.outlook.com (2603:10b6:930:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7362.24; Fri, 8 Mar 2024 16:07:04 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7362.030; Fri, 8 Mar 2024
 16:07:04 +0000
Message-ID: <44f53dce-1299-4fb0-9c4e-dbf0f5b3a351@oracle.com>
Date: Fri, 8 Mar 2024 11:06:58 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] KVM: x86: Print names of apicv inhibit reasons in
 traces
Content-Language: en-US
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        suravee.suthikulpanit@amd.com, mlevitsk@redhat.com
References: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20240214223554.1033154-1-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0305.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::9) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CYXPR10MB7974:EE_
X-MS-Office365-Filtering-Correlation-Id: 053ceae3-5eb1-4039-6304-08dc3f89cb9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	UGzAt1CXqJGsxUmdJZG64onXi9+YQLEWtLUyfFD02zltiJroDkGrAdFJMQGGyaAqrLYQ3YMh7xbKs2Wp8DWW9aaP5wvNYTf1cvbVWQGmEMtL+qL2UJOE9TMxgt9FuubqZivXEm0G4cl2fz81NQO8ZSnZ81xAHn0YXK3KdIUcNO+bG1uIItJSvM/AtK36MpMHw5p9xOFCEGj4NqPPEdMHMgP/j9B7mneFlRkGkR6UqszMzcedRh1ZpaqdpgQuGEc4SP2wct2Lv2MF/ifg6PWtBWOy5IyC5ra0LYcs9jgfbop/GD+ptNFHR0Cqx25lc1bCimTkJGC7jjGi74ML59G/havsGMYvqUrbrlLbBKmRaia0cg1hy3XqD42gqiIuebSeDNigLp90HKpLIo3bKYoL8nbWyLsNnrKNLjKFO04z3qORo4EXjh+CVlbGUw9iHymhVuRZKtwh3uodbzkZbNJTfjutP84xLRC1eDYvTpIT5QUbt4o42UQI1NjYgfOe4FOCDcZ2S1X78mB1fL+VGiIVG1gdqwwz9JczZlde/weCCR7nVkP8xzv/6X1fJFtUFTSNZgZdM8j3kHU+6ZylqFRwF2wsaw2MK7py4zCwFQVjCMxNxjPhB/gKUlXuGgYJq6KF74iw41jLDqzXUllSfWvHXUIfaMO8BxATWEjTlRXhLmo=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?eXFDaDAyM0dBY2hYTXhDbGpoSnRmcXk3aGdmZ1lodVV2eEZDZEllOFZFenpo?=
 =?utf-8?B?eEpJbVdUSXArM0dEcnk5QTRFcUNzVVF6NG5ucUd1Yzk4WUFOYlJENFUzUi9U?=
 =?utf-8?B?WDd6VG1VcnQ1QXBINkhqS0w5RG10d0IrN1plMTc3L05WZHdva0E0Wnc5cHo1?=
 =?utf-8?B?ZnF5R2g1U2gwOGVlQnBXUjdDSksxQVFvd3E4VEI5YVJTQnVNdTFKRCtQV3FF?=
 =?utf-8?B?MXJKZTliRkdSRjIwMWdZZWdoUCtlaWVISUtLTVJhemhwSVhobkQvY3lwZmU3?=
 =?utf-8?B?V1AxNm1RT0FiRjhEdG1IblhkL3dmQ2MxK1g2K2prSDljWmhHYnNQQnRwRmMz?=
 =?utf-8?B?QjcwTFdNeGdyY2grV3JaazVob2lzV254UGtUNnBudS85aXFTQTJCa2lXWXZp?=
 =?utf-8?B?azRhK0dtR01TalRYSWlqZ1RhK1RzT2hJMTNNdWt0K2RQanB6NTlCaUFHYkVQ?=
 =?utf-8?B?cVZpZmxGbmN4WVFnaFptV0VzK3EySTJ6ak8yeVJ5dnk2YUhIUzJUWkRsaUt5?=
 =?utf-8?B?T1VNYXJuL2s1TVBOakl6MjZxd2htajV4aDY1SGNGKzErZ2VOUEtBNXR5eHk2?=
 =?utf-8?B?d0w5ckcvQWYxa3paSzFiMU9CdlZTa0k2ZGFYYTFYRzkzcWJrSVQzdUV1TEdG?=
 =?utf-8?B?WjhYYmVKeXppOXNkSThDNkk4N3hFK1FsMVdxVWlHc0tQRnFBdFhJRWhYOXlC?=
 =?utf-8?B?bFJnclhObXNHRmVqd0FsV2pDOFBWaFBTZmUwdGRzOFFRaHFhSEZNZUZpVmZo?=
 =?utf-8?B?Q0grREUyaUJSdElIQWdUVzUvR3NFcEkzamdGbW1sd2pwbmd4ZlJFUnlrby9U?=
 =?utf-8?B?ZUZOUXp2NE5DZXp6VDlDbCtlcGd3VkhZcjZ3OERlanlJMENGWGNCK0R6WDVz?=
 =?utf-8?B?UnlaOEZMeWpIMmVqbUdkZFVrZnRnVG9JaElNOEx3QTJ2S2NjOFllOUJmdnA3?=
 =?utf-8?B?RGtzd3RGMWpUZDdPUzBkNVdIV1J6UHg3MDZ4ZHpCV0hwTmRwTVZlSDBTamdy?=
 =?utf-8?B?UmcxSmlrVTQ4ZmdRV1RLZGNKNlVIR08xNUFaWnBqMUltTG1id3JzRmtRQTg1?=
 =?utf-8?B?RVVJVUlsenNtSGlRbEpwSzBhcWdUWDRQalJ1MzQ2L1lKWklydXNhTTdPekF4?=
 =?utf-8?B?aDExRkx5V1pXVlgxbFd6RXpTL2kvbitUZElRWWlaaXc1MHM1RnNIS2svSGYz?=
 =?utf-8?B?Y0tIV3djY3RxSFB0ZmxIT0ZGLzVqTTRvNHc4RDdqZFFlQjJlTDBRRTUzWjNC?=
 =?utf-8?B?Y2xnOHZaRFg0bjNJODF0cnphY3kxdXlYcm5CQmM3SjZMa25UZGc5SWcvTTFT?=
 =?utf-8?B?dVZvWG45Q25OdVlYVkZuei9nQ1doSW93TFdOUHhWWnJlejVQYTFaeFRoa3FF?=
 =?utf-8?B?WW9vcEc1d3VRSDRudVo0c0dGa29XY1F5dk9UbFF0YmNiTVFWOGJBczFYQ2w3?=
 =?utf-8?B?eE1TdjBjTTg4WmxFTklhOGF0MlJwM1JNLzhyRFp4TFl5U0huUUh0SXdBQzZw?=
 =?utf-8?B?dEc3QUJVYUJVb291TTNETncyREV0ei94YytkOVpvekdKa0FzVzY2Yk56SXRC?=
 =?utf-8?B?ZGJqQVBhalNCTVBKOW1qaWFxS2JxNEVweFVFUGo2UThGMUJrSFNzT3paanRP?=
 =?utf-8?B?NWpVNG8vS2NEOFdzSSt1TWxSWDZRSUJCdWh6VTU0engvd0NuT0NIZFVYdHQ5?=
 =?utf-8?B?dUc1NExBdE5XUkhXVzRxSEdrcS8zNVNwSHpmcWsrRVo1MXNQWGRoZ1NWeERO?=
 =?utf-8?B?V0RVMTdlUkNqR0wvdlhRdUtDNlZ4ZzByRmdkWlZvN3JYTWp5MWh3N3RmdTlv?=
 =?utf-8?B?cFZVQTVIYkVYSllKR0J4SkdDS1o3Y2lJd0hKUGRuZENJU055eHdrVWxOeDV2?=
 =?utf-8?B?V3YwcUZZaTdyb1JHV1F3YU84Y25ZUmJyMDFwUkVqelJ3K0srdHNNZ1Fha3d1?=
 =?utf-8?B?eitzMytFcWJMV01GbTZyZmVEcFRZV093YWQ4RU9obzN3ZzhJRzMvVThOVVlE?=
 =?utf-8?B?YW1ROElkK2ZQWXBwYUpHVXF1WFF5cW9IK2Jua3o0T2pzcDVqKzNGbkVGMEZT?=
 =?utf-8?B?ZlB2blE0OHNTSHYzTXBlbGoxRTN1ZE5wNkJraisvQVdYYTVrbmZKcENnczBa?=
 =?utf-8?B?U1g3dmw3UVdWM1JQWm1sQm9RakwwZVRpNlkvOE1NWVVEelFXbS8yVENGTTlY?=
 =?utf-8?B?ZVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	o4YkBHHlXj0D4EOZ4OVsQ7g+rro4Pye1kCV+10JCIGyoh56zbthhA5CjaB8YF4/TYj+J5zwrkibcWNOyRJdVBxeFLOSFnm0uc5hI1i2GIjp26QyRouYsQNFmgnmql/JzqSNdmJ3c/kLUe8eUO5XYkuh+V5YYm8YKqajQv6VLca9dBBv0Joi6YFgeOpxHpuNPS0tre8v0asfACc53j33ubXNtZcjRqfUNXtUQSd+tXb7FDzN51IUI7lw312IN4r/rhUKvxc1cVX2Bo4YMch4tN6uUuravxSySrNAerBRR5lNZFBPXyhVWkLAhrwumyL7nPOkuWKgnd4YB3HD/hKs+p+ogM015dzM0GY9fxiBOXiPoLIE3mv850DYmW1I2M5m2DtbRagVYxXaUHwxoDQukboeTB4MEft5ccny2hmeE8qJ1Hzhl/LhYlz7YDcaDSTVbUp6Y2Zi0O04WA1BqakDFAcgW3o8K7yijyLgDgdZgpZllbbM56B8BZzvOfF6WV0O+lVebnkB5HUnIhxs15l9MozVpVKz9uMTw1swQNI/esFy3sa6N/MMvoVmstohA0WunsK1GsK/8qloOliqZ1wUFLI1iUOZ4YoLvV6pjKj7J4M0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 053ceae3-5eb1-4039-6304-08dc3f89cb9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2024 16:07:04.1707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KzAEC6MlvqysFg7Vtu/gVpweBrKh7bCviobHIPEA/3F7dQPsqZtdiN8Jfhs/KR/ZVaGZRVuIOcM06laMiFI7o0c601hvXrjzypeOQ25c9Bw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR10MB7974
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-08_08,2024-03-06_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2403080129
X-Proofpoint-ORIG-GUID: pvL-3l7zilbGkkrlOdosCOSQbsNQZXBL
X-Proofpoint-GUID: pvL-3l7zilbGkkrlOdosCOSQbsNQZXBL



On 2/14/24 17:35, Alejandro Jimenez wrote:
> Use the tracing infrastructure helper __print_flags() for printing flag
> bitfields, to enhance the trace output by displaying a string describing
> each of the inhibit reasons set.
> 
> The kvm_apicv_inhibit_changed tracepoint currently shows the raw bitmap
> value, requiring the user to consult the source file where the inhbit
> reasons are defined to decode the trace output.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> 
> ---
> checkpatch reports an error:
> ERROR: Macros with complex values should be enclosed in parentheses
> 
> but that seems common for other patches that also use a macro to define an array
> of struct trace_print_flags used by __print_flags().
> 
> I did not include an example of the new traces in the commit message since they
> are longer than 80 columns, but perhaps that is desirable. e.g.:
> 
> qemu-system-x86-6961    [055] .....  1779.344065: kvm_apicv_inhibit_changed: set reason=2, inhibits=0x4 ABSENT
> qemu-system-x86-6961    [055] .....  1779.356710: kvm_apicv_inhibit_changed: cleared reason=2, inhibits=0x0
> 
> qemu-system-x86-9912    [137] ..... 57106.196107: kvm_apicv_inhibit_changed: set reason=8, inhibits=0x300 IRQWIN|PIT_REINJ
> qemu-system-x86-9912    [137] ..... 57106.196115: kvm_apicv_inhibit_changed: cleared reason=8, inhibits=0x200 PIT_REINJ
> ---
>   arch/x86/kvm/trace.h | 28 ++++++++++++++++++++++++++--
>   1 file changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index b82e6ed4f024..8469e59dfce2 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -1372,6 +1372,27 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
>   		  __entry->vcpu_id, __entry->timer_index)
>   );
>   
> +/*
> + * The inhibit flags in this flag array must be kept in sync with the
> + * kvm_apicv_inhibit enum members in <asm/kvm_host.h>.
> + */
> +#define APICV_INHIBIT_FLAGS \
> +	{ BIT(APICV_INHIBIT_REASON_DISABLE),		 "DISABLED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_HYPERV),		 "HYPERV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_ABSENT),		 "ABSENT" }, \
> +	{ BIT(APICV_INHIBIT_REASON_BLOCKIRQ),		 "BLOCKIRQ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED), "PHYS_ID_ALIASED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED),	 "APIC_ID_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED),	 "APIC_BASE_MOD" }, \
> +	{ BIT(APICV_INHIBIT_REASON_NESTED),		 "NESTED" }, \
> +	{ BIT(APICV_INHIBIT_REASON_IRQWIN),		 "IRQWIN" }, \
> +	{ BIT(APICV_INHIBIT_REASON_PIT_REINJ),		 "PIT_REINJ" }, \
> +	{ BIT(APICV_INHIBIT_REASON_SEV),		 "SEV" }, \
> +	{ BIT(APICV_INHIBIT_REASON_LOGICAL_ID_ALIASED),	 "LOG_ID_ALIASED" } \
> +
> +#define show_inhibit_reasons(inhibits) \
> +	__print_flags(inhibits, "|", APICV_INHIBIT_FLAGS)
> +
>   TRACE_EVENT(kvm_apicv_inhibit_changed,
>   	    TP_PROTO(int reason, bool set, unsigned long inhibits),
>   	    TP_ARGS(reason, set, inhibits),
> @@ -1388,9 +1409,12 @@ TRACE_EVENT(kvm_apicv_inhibit_changed,
>   		__entry->inhibits = inhibits;
>   	),
>   
> -	TP_printk("%s reason=%u, inhibits=0x%lx",
> +	TP_printk("%s reason=%u, inhibits=0x%lx%s%s",
>   		  __entry->set ? "set" : "cleared",
> -		  __entry->reason, __entry->inhibits)
> +		  __entry->reason, __entry->inhibits,
> +		  __entry->inhibits ? " " : "",
> +		  __entry->inhibits ?
> +		  show_inhibit_reasons(__entry->inhibits) : "")
>   );
>   
>   TRACE_EVENT(kvm_apicv_accept_irq,
> 
> base-commit: 7455665a3521aa7b56245c0a2810f748adc5fdd4
ping..


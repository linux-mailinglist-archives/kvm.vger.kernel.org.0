Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBAE44AA258
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242146AbiBDVdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:33:39 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23534 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241174AbiBDVdi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:33:38 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214K1OB9015768;
        Fri, 4 Feb 2022 21:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=V96kPHPcbaEFpFcl5wtymOsrVxw9OhMcRz8jBgjtioQ=;
 b=GpiJddThV7qffYS63IfRz3lxlkToiOMYssovW1yy/yWX9A6mdNbMeQ3tPo/Mvqh5QrGO
 2jX8dN76fdt4ZNZSEX+2WZLgtYNGlySY59PVsqBo9heD/Ztr5TsKvWMRcNL2BAACgKR0
 c0rhKLZb8CEfCjSrWS9PdgAzacL/LMEzbrjEPQ7F3L8nAOJQ1F8Uz4AI2qBdgbZfZkZ2
 MP5aYjv03x/TX4O6Zaq8lTz4I7OVZCvYODxYZku+Rl9ishkxNpvakl8FKw5S4CzcEtTq
 h1/sxaGgsYGUimith4JVXAk83nS2+mJRk1vRe4kVrbvEiwOf89cnQudatZcfci6IjvUS Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0yu5qe50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:33:37 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LRbhL017632;
        Fri, 4 Feb 2022 21:33:37 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0yu5qe4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:33:37 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LWbPX029014;
        Fri, 4 Feb 2022 21:33:36 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02wdc.us.ibm.com with ESMTP id 3e0r0kb4nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:33:36 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LXZ7C29753792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:33:35 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CC4A28060;
        Fri,  4 Feb 2022 21:33:35 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 966442805C;
        Fri,  4 Feb 2022 21:33:30 +0000 (GMT)
Received: from [9.211.82.52] (unknown [9.211.82.52])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:33:30 +0000 (GMT)
Message-ID: <545e631c-8e0d-2aab-8429-b69da6198dae@linux.ibm.com>
Date:   Fri, 4 Feb 2022 16:33:29 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 00/30] KVM: s390: enable zPCI for interpretive
 execution
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d0cu8XSu5BX3OZVwNDzD1chPwFbGseqL
X-Proofpoint-GUID: KOD5tdnq1kfTiTbwm0AVeMg-E36OZ5uv
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=885 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040119
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/4/22 4:15 PM, Matthew Rosato wrote:
> Enable interpretive execution of zPCI instructions + adapter interruption
> forwarding for s390x KVM vfio-pci.  This is done by introducing a series
> of new vfio-pci feature ioctls that are unique vfio-pci-zdev (s390x) and
> are used to negotiate the various aspects of zPCI interpretation setup.
> By allowing intepretation of zPCI instructions and firmware delivery of
> interrupts to guests, we can significantly reduce the frequency of guest
> SIE exits for zPCI.  We then see additional gains by handling a hot-path
> instruction that can still intercept to the hypervisor (RPCIT) directly
> in kvm.
> 
>  From the perspective of guest configuration, you passthrough zPCI devices
> in the same manner as before, with intepretation support being used by
> default if available in kernel+qemu.
> 
> Will reply with a link to the associated QEMU series.
https://lore.kernel.org/qemu-devel/20220204211918.321924-1-mjrosato@linux.ibm.com/

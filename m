Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11A7D4CD0D0
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 10:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236171AbiCDJJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 04:09:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237368AbiCDJHp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 04:07:45 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259A01A271C;
        Fri,  4 Mar 2022 01:06:19 -0800 (PST)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4K92466Vxczdb2s;
        Fri,  4 Mar 2022 17:04:54 +0800 (CST)
Received: from [10.67.103.22] (10.67.103.22) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 4 Mar
 2022 17:06:13 +0800
Message-ID: <86cd1e47-9a4b-f340-1b0c-cf1d39584a47@hisilicon.com>
Date:   Fri, 4 Mar 2022 17:06:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH v8 2/9] crypto: hisilicon/qm: Move few definitions to
 common header
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>
CC:     <linux-pci@vger.kernel.org>, <alex.williamson@redhat.com>,
        <jgg@nvidia.com>, <cohuck@redhat.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <linuxarm@huawei.com>,
        <liulongfang@huawei.com>, <prime.zeng@hisilicon.com>,
        <jonathan.cameron@huawei.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-3-shameerali.kolothum.thodi@huawei.com>
From:   Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <20220303230131.2103-3-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.103.22]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Longfang Liu <liulongfang@huawei.com>>
> Move Doorbell and Mailbox definitions to common header file.
> Also export QM mailbox functions.
> 
> This will be useful when we introduce VFIO PCI HiSilicon ACC live
> migration driver.
> 
> Signed-off-by: Longfang Liu <liulongfang@huawei.com>
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Looks good to me, so:

Acked-by: Zhou Wang <wangzhou1@hisilicon.com>

Thanks,
Zhou

> ---
>  drivers/crypto/hisilicon/qm.c | 58 +++++++++++------------------------
>  include/linux/hisi_acc_qm.h   | 38 +++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
> index ed23e1d3fa27..c88e013371af 100644
> --- a/drivers/crypto/hisilicon/qm.c
> +++ b/drivers/crypto/hisilicon/qm.c
> @@ -33,23 +33,6 @@
>  #define QM_ABNORMAL_EVENT_IRQ_VECTOR	3
>  
>  /* mailbox */
> -#define QM_MB_CMD_SQC			0x0
> -#define QM_MB_CMD_CQC			0x1
> -#define QM_MB_CMD_EQC			0x2
> -#define QM_MB_CMD_AEQC			0x3
> -#define QM_MB_CMD_SQC_BT		0x4
> -#define QM_MB_CMD_CQC_BT		0x5
> -#define QM_MB_CMD_SQC_VFT_V2		0x6
> -#define QM_MB_CMD_STOP_QP		0x8
> -#define QM_MB_CMD_SRC			0xc
> -#define QM_MB_CMD_DST			0xd
> -
> -#define QM_MB_CMD_SEND_BASE		0x300
> -#define QM_MB_EVENT_SHIFT		8
> -#define QM_MB_BUSY_SHIFT		13
> -#define QM_MB_OP_SHIFT			14
> -#define QM_MB_CMD_DATA_ADDR_L		0x304
> -#define QM_MB_CMD_DATA_ADDR_H		0x308
>  #define QM_MB_PING_ALL_VFS		0xffff
>  #define QM_MB_CMD_DATA_SHIFT		32
>  #define QM_MB_CMD_DATA_MASK		GENMASK(31, 0)
> @@ -103,19 +86,12 @@
>  #define QM_DB_CMD_SHIFT_V1		16
>  #define QM_DB_INDEX_SHIFT_V1		32
>  #define QM_DB_PRIORITY_SHIFT_V1		48
> -#define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
> -#define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
>  #define QM_QUE_ISO_CFG_V		0x0030
>  #define QM_PAGE_SIZE			0x0034
>  #define QM_QUE_ISO_EN			0x100154
>  #define QM_CAPBILITY			0x100158
>  #define QM_QP_NUN_MASK			GENMASK(10, 0)
>  #define QM_QP_DB_INTERVAL		0x10000
> -#define QM_QP_MAX_NUM_SHIFT		11
> -#define QM_DB_CMD_SHIFT_V2		12
> -#define QM_DB_RAND_SHIFT_V2		16
> -#define QM_DB_INDEX_SHIFT_V2		32
> -#define QM_DB_PRIORITY_SHIFT_V2		48
>  
>  #define QM_MEM_START_INIT		0x100040
>  #define QM_MEM_INIT_DONE		0x100044
> @@ -693,7 +669,7 @@ static void qm_mb_pre_init(struct qm_mailbox *mailbox, u8 cmd,
>  }
>  
>  /* return 0 mailbox ready, -ETIMEDOUT hardware timeout */
> -static int qm_wait_mb_ready(struct hisi_qm *qm)
> +int hisi_qm_wait_mb_ready(struct hisi_qm *qm)
>  {
>  	u32 val;
>  
> @@ -701,6 +677,7 @@ static int qm_wait_mb_ready(struct hisi_qm *qm)
>  					  val, !((val >> QM_MB_BUSY_SHIFT) &
>  					  0x1), POLL_PERIOD, POLL_TIMEOUT);
>  }
> +EXPORT_SYMBOL_GPL(hisi_qm_wait_mb_ready);
>  
>  /* 128 bit should be written to hardware at one time to trigger a mailbox */
>  static void qm_mb_write(struct hisi_qm *qm, const void *src)
> @@ -726,14 +703,14 @@ static void qm_mb_write(struct hisi_qm *qm, const void *src)
>  
>  static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
>  {
> -	if (unlikely(qm_wait_mb_ready(qm))) {
> +	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
>  		dev_err(&qm->pdev->dev, "QM mailbox is busy to start!\n");
>  		goto mb_busy;
>  	}
>  
>  	qm_mb_write(qm, mailbox);
>  
> -	if (unlikely(qm_wait_mb_ready(qm))) {
> +	if (unlikely(hisi_qm_wait_mb_ready(qm))) {
>  		dev_err(&qm->pdev->dev, "QM mailbox operation timeout!\n");
>  		goto mb_busy;
>  	}
> @@ -745,8 +722,8 @@ static int qm_mb_nolock(struct hisi_qm *qm, struct qm_mailbox *mailbox)
>  	return -EBUSY;
>  }
>  
> -static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> -		 bool op)
> +int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> +	       bool op)
>  {
>  	struct qm_mailbox mailbox;
>  	int ret;
> @@ -762,6 +739,7 @@ static int qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
>  
>  	return ret;
>  }
> +EXPORT_SYMBOL_GPL(hisi_qm_mb);
>  
>  static void qm_db_v1(struct hisi_qm *qm, u16 qn, u8 cmd, u16 index, u8 priority)
>  {
> @@ -1351,7 +1329,7 @@ static int qm_get_vft_v2(struct hisi_qm *qm, u32 *base, u32 *number)
>  	u64 sqc_vft;
>  	int ret;
>  
> -	ret = qm_mb(qm, QM_MB_CMD_SQC_VFT_V2, 0, 0, 1);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_VFT_V2, 0, 0, 1);
>  	if (ret)
>  		return ret;
>  
> @@ -1725,12 +1703,12 @@ static int dump_show(struct hisi_qm *qm, void *info,
>  
>  static int qm_dump_sqc_raw(struct hisi_qm *qm, dma_addr_t dma_addr, u16 qp_id)
>  {
> -	return qm_mb(qm, QM_MB_CMD_SQC, dma_addr, qp_id, 1);
> +	return hisi_qm_mb(qm, QM_MB_CMD_SQC, dma_addr, qp_id, 1);
>  }
>  
>  static int qm_dump_cqc_raw(struct hisi_qm *qm, dma_addr_t dma_addr, u16 qp_id)
>  {
> -	return qm_mb(qm, QM_MB_CMD_CQC, dma_addr, qp_id, 1);
> +	return hisi_qm_mb(qm, QM_MB_CMD_CQC, dma_addr, qp_id, 1);
>  }
>  
>  static int qm_sqc_dump(struct hisi_qm *qm, const char *s)
> @@ -1842,7 +1820,7 @@ static int qm_eqc_aeqc_dump(struct hisi_qm *qm, char *s, size_t size,
>  	if (IS_ERR(xeqc))
>  		return PTR_ERR(xeqc);
>  
> -	ret = qm_mb(qm, cmd, xeqc_dma, 0, 1);
> +	ret = hisi_qm_mb(qm, cmd, xeqc_dma, 0, 1);
>  	if (ret)
>  		goto err_free_ctx;
>  
> @@ -2495,7 +2473,7 @@ static int qm_ping_pf(struct hisi_qm *qm, u64 cmd)
>  
>  static int qm_stop_qp(struct hisi_qp *qp)
>  {
> -	return qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
> +	return hisi_qm_mb(qp->qm, QM_MB_CMD_STOP_QP, 0, qp->qp_id, 0);
>  }
>  
>  static int qm_set_msi(struct hisi_qm *qm, bool set)
> @@ -2763,7 +2741,7 @@ static int qm_sq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
>  		return -ENOMEM;
>  	}
>  
> -	ret = qm_mb(qm, QM_MB_CMD_SQC, sqc_dma, qp_id, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC, sqc_dma, qp_id, 0);
>  	dma_unmap_single(dev, sqc_dma, sizeof(struct qm_sqc), DMA_TO_DEVICE);
>  	kfree(sqc);
>  
> @@ -2804,7 +2782,7 @@ static int qm_cq_ctx_cfg(struct hisi_qp *qp, int qp_id, u32 pasid)
>  		return -ENOMEM;
>  	}
>  
> -	ret = qm_mb(qm, QM_MB_CMD_CQC, cqc_dma, qp_id, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_CQC, cqc_dma, qp_id, 0);
>  	dma_unmap_single(dev, cqc_dma, sizeof(struct qm_cqc), DMA_TO_DEVICE);
>  	kfree(cqc);
>  
> @@ -3655,7 +3633,7 @@ static int qm_eq_ctx_cfg(struct hisi_qm *qm)
>  		return -ENOMEM;
>  	}
>  
> -	ret = qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_EQC, eqc_dma, 0, 0);
>  	dma_unmap_single(dev, eqc_dma, sizeof(struct qm_eqc), DMA_TO_DEVICE);
>  	kfree(eqc);
>  
> @@ -3684,7 +3662,7 @@ static int qm_aeq_ctx_cfg(struct hisi_qm *qm)
>  		return -ENOMEM;
>  	}
>  
> -	ret = qm_mb(qm, QM_MB_CMD_AEQC, aeqc_dma, 0, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_AEQC, aeqc_dma, 0, 0);
>  	dma_unmap_single(dev, aeqc_dma, sizeof(struct qm_aeqc), DMA_TO_DEVICE);
>  	kfree(aeqc);
>  
> @@ -3723,11 +3701,11 @@ static int __hisi_qm_start(struct hisi_qm *qm)
>  	if (ret)
>  		return ret;
>  
> -	ret = qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_SQC_BT, qm->sqc_dma, 0, 0);
>  	if (ret)
>  		return ret;
>  
> -	ret = qm_mb(qm, QM_MB_CMD_CQC_BT, qm->cqc_dma, 0, 0);
> +	ret = hisi_qm_mb(qm, QM_MB_CMD_CQC_BT, qm->cqc_dma, 0, 0);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
> index 3068093229a5..6a6477c34666 100644
> --- a/include/linux/hisi_acc_qm.h
> +++ b/include/linux/hisi_acc_qm.h
> @@ -34,6 +34,40 @@
>  #define QM_WUSER_M_CFG_ENABLE		0x1000a8
>  #define WUSER_M_CFG_ENABLE		0xffffffff
>  
> +/* mailbox */
> +#define QM_MB_CMD_SQC                   0x0
> +#define QM_MB_CMD_CQC                   0x1
> +#define QM_MB_CMD_EQC                   0x2
> +#define QM_MB_CMD_AEQC                  0x3
> +#define QM_MB_CMD_SQC_BT                0x4
> +#define QM_MB_CMD_CQC_BT                0x5
> +#define QM_MB_CMD_SQC_VFT_V2            0x6
> +#define QM_MB_CMD_STOP_QP               0x8
> +#define QM_MB_CMD_SRC                   0xc
> +#define QM_MB_CMD_DST                   0xd
> +
> +#define QM_MB_CMD_SEND_BASE		0x300
> +#define QM_MB_EVENT_SHIFT               8
> +#define QM_MB_BUSY_SHIFT		13
> +#define QM_MB_OP_SHIFT			14
> +#define QM_MB_CMD_DATA_ADDR_L		0x304
> +#define QM_MB_CMD_DATA_ADDR_H		0x308
> +#define QM_MB_MAX_WAIT_CNT		6000
> +
> +/* doorbell */
> +#define QM_DOORBELL_CMD_SQ              0
> +#define QM_DOORBELL_CMD_CQ              1
> +#define QM_DOORBELL_CMD_EQ              2
> +#define QM_DOORBELL_CMD_AEQ             3
> +
> +#define QM_DOORBELL_SQ_CQ_BASE_V2	0x1000
> +#define QM_DOORBELL_EQ_AEQ_BASE_V2	0x2000
> +#define QM_QP_MAX_NUM_SHIFT             11
> +#define QM_DB_CMD_SHIFT_V2		12
> +#define QM_DB_RAND_SHIFT_V2		16
> +#define QM_DB_INDEX_SHIFT_V2		32
> +#define QM_DB_PRIORITY_SHIFT_V2		48
> +
>  /* qm cache */
>  #define QM_CACHE_CTL			0x100050
>  #define SQC_CACHE_ENABLE		BIT(0)
> @@ -414,6 +448,10 @@ pci_ers_result_t hisi_qm_dev_slot_reset(struct pci_dev *pdev);
>  void hisi_qm_reset_prepare(struct pci_dev *pdev);
>  void hisi_qm_reset_done(struct pci_dev *pdev);
>  
> +int hisi_qm_wait_mb_ready(struct hisi_qm *qm);
> +int hisi_qm_mb(struct hisi_qm *qm, u8 cmd, dma_addr_t dma_addr, u16 queue,
> +	       bool op);
> +
>  struct hisi_acc_sgl_pool;
>  struct hisi_acc_hw_sgl *hisi_acc_sg_buf_map_to_hw_sgl(struct device *dev,
>  	struct scatterlist *sgl, struct hisi_acc_sgl_pool *pool,
> 
